
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class TeleportCameraPlayer : UdonSharpBehaviour
{
    [SerializeField] private string[] displayNames;
    [SerializeField] private GameObject VRCWorld;
    [SerializeField] private Transform teleportPos;
    [SerializeField] private GameObject recorderRoot;
    [SerializeField] private GameObject basePPS;
    [SerializeField] private bool delayTeleport;
    [SerializeField] private float delayTeleportTime = 10.0f;

    private float _delayCount;
    private bool _nameCheck;

	[Header("カメラマンがspatial blendを0に変更するAudiosource")]
	[SerializeField] private AudioSource[] audios;

    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        if(player == Networking.LocalPlayer)
        {
            for (int i = 0; i < displayNames.Length; i++)
            {
                if(player.displayName == displayNames[i])
                {
                    _nameCheck = true;
                    break;
                }
            }

            if (!_nameCheck)
            {
                recorderRoot.SetActive(false);
            }
            else
            {
                if (!delayTeleport)
                {
                    player.TeleportTo(teleportPos.position, teleportPos.rotation);
                    VRCWorld.transform.position = teleportPos.position;
                    VRCWorld.transform.rotation = teleportPos.rotation;

                    if (!recorderRoot.activeSelf) recorderRoot.SetActive(true);
                    basePPS.SetActive(false);

					foreach(AudioSource audio in audios) audio.spatialBlend = 0f;
                }
            }
        }
    }

    private void Update()
    {
        if (!_nameCheck)
        {
            return;
        }
        else
        {
            if (delayTeleport)
            {
                _delayCount += Time.deltaTime / delayTeleportTime;
                if(_delayCount >= 1.0f)
                {
                    Networking.LocalPlayer.TeleportTo(teleportPos.position, teleportPos.rotation);
                    VRCWorld.transform.position = teleportPos.position;
                    VRCWorld.transform.rotation = teleportPos.rotation;

                    if (!recorderRoot.activeSelf) recorderRoot.SetActive(true);
                    basePPS.SetActive(false);

                    foreach (AudioSource audio in audios) audio.spatialBlend = 0f;

                    delayTeleport = false;
                    return;
                }
            }
        }
    }
}
