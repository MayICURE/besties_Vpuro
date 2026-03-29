
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class OnEnterTeleporter : UdonSharpBehaviour
{
	[SerializeField]
	private Transform tereportTr;

	public override void OnPlayerTriggerEnter(VRCPlayerApi player)
	{
		if(!player.isLocal) return;
		Networking.LocalPlayer.TeleportTo(tereportTr.position, tereportTr.rotation);
	}
}
