
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class PuroBGMChange : UdonSharpBehaviour
{

    public PuroBGMCrossFade puroBGMCrossFade; 

    /*
    public override void OnPlayerRespawn(VRCPlayerApi player)
    {
        if (player == Networking.LocalPlayer) 
        {
            puroBGMCrossFade.ChangeInitiate0();
        }
    }
    */

    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        if (player == Networking.LocalPlayer)
        {
            puroBGMCrossFade.ChangeInitiate1();
        }
    }

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if (player == Networking.LocalPlayer)
        {
            puroBGMCrossFade.ChangeInitiate0();
        }
    }
}
