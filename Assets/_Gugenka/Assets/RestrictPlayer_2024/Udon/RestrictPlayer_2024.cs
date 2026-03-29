
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

namespace Gugenka
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.None)]
    public class RestrictPlayer_2024 : UdonSharpBehaviour
	{
		[SerializeField]
		bool isTicketCheckSkip = false;
		[SerializeField]
		private GameObject noTicketObj;
		[SerializeField]
		private Transform withTicketTr, noTicketTr;
		[Header("Scene Setting")]
		[SerializeField]
		private Transform respawnTr;
		[SerializeField]
		private GameObject[] disableObjects;

		[SerializeField]
		private GameObject[] errorToggleObjects;
		[SerializeField]
		private bool isWaitTeleport = false;
		[SerializeField]
		private GameObject flag;
		bool isHasTicket = false;
		float time = 0f;
		bool isWarnEnd = false;
		bool moved = false;
		[SerializeField]
		private bool isJoinSetTrigger = false;
		[SerializeField]
		private Animator[] anims;
		bool isDebugNoTicket;
		
		private void Update()
		{
			if(!isWaitTeleport) return;
			if(isWarnEnd) return;
			if(moved) return;
			if(flag.activeSelf)
			{
				isWarnEnd = true;
				if(isTicketCheckSkip && !isDebugNoTicket) TicketAction();
				if (isHasTicket)//演出終了までに判定完了
				{
					TeleportTicketPlayer();
				}
				else
				{
					isWarnEnd = true;
				}
			}
		}

		public override void OnPlayerJoined(VRCPlayerApi player)
		{
			if(isJoinSetTrigger) foreach(Animator anim in anims) anim.SetTrigger("trig");
		}


		public void OnCheckedTicketSuccess(bool hasTicket)
        {
            if (hasTicket)
            {
                Debug.Log("あなたはチケット購入者です。");
				TicketAction();
			}
            else
            {
                Debug.Log("あなたはチケット購入者ではありません。");
				if(!isTicketCheckSkip) NoTicketAction();
				else TicketAction();
			}
        }

        public void OnCheckedTicketError()
        {
            Debug.Log("チケットをチェックする処理の中でエラーが発生しました。あなたがチケット購入者かどうかが判別できません。");
			ErrorTicketAction();
		}

		public void TicketAction()
		{
			respawnTr.SetPositionAndRotation(withTicketTr.position, withTicketTr.rotation);
			if(!isWaitTeleport) return;//Networking.LocalPlayer.TeleportTo(withTicketTr.position, withTicketTr.rotation);
			else
			{
				if(isWarnEnd) TeleportTicketPlayer();
				else isHasTicket = true;
			}
		}

		public void NoTicketAction()
		{
			isDebugNoTicket = true;
			foreach (GameObject obj in disableObjects) obj.SetActive(false);
			noTicketObj.SetActive(true);
			respawnTr.SetPositionAndRotation(noTicketTr.position, noTicketTr.rotation);
			Networking.LocalPlayer.TeleportTo(noTicketTr.position, noTicketTr.rotation);
		}
		public void ErrorTicketAction()
		{
			foreach(GameObject obj in errorToggleObjects) obj.SetActive(!obj.activeSelf);
			NoTicketAction();
		}

		public void TeleportTicketPlayer()
		{
			VRCPlayerApi localplayer = Networking.LocalPlayer;
			Vector3 warppos = localplayer.GetPosition();
			warppos.x -= 1500f;
			localplayer.TeleportTo(warppos, localplayer.GetRotation());
			moved = true;
			Debug.Log("Moved");
		}
    }
}
