
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MultiVideoDemoButton : UdonSharpBehaviour
{
	public UdonBehaviour CallUdon;
	public string CallEvent;
	public GameObject ButtonObj;
	public MultiVideoPlayerManager manager;
	public double startTime = 0;

	void Start()
    {
        
    }
	public override void Interact()
	{
		manager.buttonStartTime = startTime;
		manager.InteractCall();
		SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, "GlobalButton");
	}
	public void GlobalButton()
	{
		//CallUdon.SendCustomEvent(CallEvent);
		ButtonObj.SetActive(false);
	}
}
