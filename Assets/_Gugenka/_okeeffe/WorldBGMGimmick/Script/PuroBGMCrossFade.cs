
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PuroBGMCrossFade : UdonSharpBehaviour
{
    public AudioSource[] audioSources;
    private int sourceLength;
    private int newNum;
    private int oldNum;

    public float maxVolume = 1.0f;
    private float[] prevPlayTime;

    public bool isInitialized = false;
    public float audioFadeTime = 2.0f;
    private float time = 0f;
    void Start()
    {
        sourceLength = audioSources.Length;
        prevPlayTime = new float[audioSources.Length];
    }

    private void Update()
    {
        if (isInitialized) 
        {
            time += Time.deltaTime;
            if (time > audioFadeTime)
            {
                prevPlayTime[oldNum] = audioSources[oldNum].time;
                audioSources[oldNum].volume = 0f;
                audioSources[newNum].volume = maxVolume;
                audioSources[oldNum].gameObject.SetActive(false);
                audioSources[oldNum].gameObject.SetActive(true);
                isInitialized = false;
                time = 0f;
                return;
            }
            audioSources[oldNum].volume = Mathf.Lerp(0.0f, maxVolume, 1 - (time / audioFadeTime));
            audioSources[newNum].volume = Mathf.Lerp(0.0f, maxVolume, time / audioFadeTime);
        }
    }

    public void Initiate() 
    {
        for (int i = 0; i < sourceLength; i++) 
        {
            if (i == newNum || i == oldNum)
            {
                audioSources[i].gameObject.SetActive(true);
            }
            else 
            {
                audioSources[i].gameObject.SetActive(false);
            }

            if (i == newNum) 
            {
                audioSources[i].time = prevPlayTime[i];
            }
        }

        if (isInitialized) 
        {
            time = audioFadeTime - time;
        }

        isInitialized = true;
    }

    public void ChangeInitiate0() //PuroメインBGM
    {
        oldNum = newNum;
        newNum = 0;
        Initiate();
    }

    public void ChangeInitiate1() //遺跡BGM
    {
        oldNum = newNum;
        newNum = 1;
        Initiate();
    }
}
