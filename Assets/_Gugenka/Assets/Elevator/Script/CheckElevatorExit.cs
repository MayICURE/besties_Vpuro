
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace VFes2023
{
    public class CheckElevatorExit : UdonSharpBehaviour
    {
        [SerializeField] private Animator elevatorAnimator;
        [SerializeField] private GameObject elevatorCollider;

        public override void OnPlayerTriggerExit(VRCPlayerApi player)
        {
            if (player == Networking.LocalPlayer)
            {
                elevatorCollider.SetActive(true);
                elevatorAnimator.SetTrigger("Close");
            }
        }
    }
}
