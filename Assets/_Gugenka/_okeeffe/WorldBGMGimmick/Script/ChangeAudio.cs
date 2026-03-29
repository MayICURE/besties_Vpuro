
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class ChangeAudio : UdonSharpBehaviour
{
    public AudioCrossfade AudioManeger;
    public bool SetInside;
    private bool SetOutside;
    public bool SetB1Floor;

    void Start()
    {
        
    }

    private void Update()
    {
        
    }

    public override void OnPlayerRespawn(VRCPlayerApi player)
    {
        if(player == Networking.LocalPlayer)
        {
            AudioManeger.ChangeInitiate0();
            SetInside = true;
            SetOutside = false;
            return;
        }
    }

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (player != Networking.LocalPlayer) return;
        if (!SetInside && SetOutside)
        {
            AudioManeger.ChangeInitiate0();
            SetInside = true;
            SetOutside = false;
            return;
        }
        else if (SetInside && !SetOutside)
        {
            AudioManeger.ChangeInitiate1();
            SetInside = false;
            SetOutside = true;
        }
        else if (SetB1Floor)
        {
            AudioManeger.ChangeInitiate2();
        }
    }
}
