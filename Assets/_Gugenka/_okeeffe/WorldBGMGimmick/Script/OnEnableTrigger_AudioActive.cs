
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.None)]
public class OnEnableTrigger_AudioActive : UdonSharpBehaviour
{
    [SerializeField]
    AudioSource[] audios = { };

    [SerializeField]
    float[] volumes = { };

    [SerializeField]
    float speed = 0.01f;

    bool isFadeOut;

    private void OnEnable()
    {
        isFadeOut = true;
        LoopEntry();
    }

    private void OnDisable()
    {
        isFadeOut = false;
        LoopEntry();
    }

    bool isLooping = false;

    private void LoopEntry()
    {
        if (isLooping)
        {
            return;
        }

        isLooping = true;

        for (var i = 0; i < audios.Length; i++)
        {
            var audio = audios[i];

            if (audio != null && audio.mute)
            {
                audio.mute = false;
            }
        }

        Loop();
    }

    private bool LoopCondition()
    {
        var loopCondition = false;

        for (var i = 0; i < audios.Length; i++)
        {
            var audio = audios[i];

            if (audio != null)
            {
                loopCondition |= Mathf.Abs(audio.volume - (isFadeOut ? 0f : volumes[i])) > speed * 0.01f;
            }
        }

        return loopCondition;
    }

    private void LoopExit()
    {
        for (var i = 0; i < audios.Length; i++)
        {
            var audio = audios[i];

            if (audio != null)
            {
                if (isFadeOut)
                {
                    audio.volume = 0f;
                    audio.mute = true;
                }
                else
                {
                    audio.volume = volumes[i];
                    audio.mute = false;
                }
            }
        }

        isLooping = false;
    }

    public void Loop()
    {
        for (var i = 0; i < audios.Length; i++)
        {
            var audio = audios[i];

            if (audio != null)
            {
                audio.volume = Mathf.Lerp(audio.volume, isFadeOut ? 0f : volumes[i], speed);
            }
        }

        if (LoopCondition())
        {
            SendCustomEventDelayedFrames(nameof(Loop), 0);
        }
        else
        {
            LoopExit();
        }
    }
}
