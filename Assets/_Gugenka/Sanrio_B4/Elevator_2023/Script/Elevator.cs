
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class Elevator : UdonSharpBehaviour
{
    [SerializeField] Animator elevatorAnimator;
    [SerializeField] GameObject colliderRoot;
    [SerializeField] GameObject VRCWorld;
    [SerializeField] Transform respawnPos;

    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        if(player == Networking.LocalPlayer)
        {
            elevatorAnimator.SetTrigger("close");
            colliderRoot.SetActive(true);
            VRCWorld.transform.position = respawnPos.position;
        }
    }
}
