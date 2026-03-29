
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class TeleportButton : UdonSharpBehaviour
{
    public Transform target;

    void Start()
    {
        
    }

    public override void Interact()
    {
        Networking.LocalPlayer.TeleportTo(target.transform.position, target.transform.rotation);
    }
}
