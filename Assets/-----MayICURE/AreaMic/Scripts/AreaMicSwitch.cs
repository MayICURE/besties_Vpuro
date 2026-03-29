
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class AreaMicSwitch : UdonSharpBehaviour
{
    [SerializeField] private AreaMic areaMic = null;
    void Start()
    {
        
    }
    public override void Interact()
    {
        if(areaMic == null) return;
        areaMic.ToggleState();
    }
}
