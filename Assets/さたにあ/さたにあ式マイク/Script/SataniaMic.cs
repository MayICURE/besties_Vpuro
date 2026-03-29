//Copyright (c) 2024 SataniaShopping
//Released under the VN3 license
//https://drive.google.com/file/d/1REq1aSBODwCZ9eyzq3Es-pjlv-a7K-4l/view?usp=drive_link

using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using com.satania.player.volume;

#if !COMPILER_UDONSHARP && UNITY_EDITOR
using UnityEditor;
using UnityEngine.SceneManagement;
using System.Linq;
#endif

namespace com.satania.sataniamic
{
    [UdonBehaviourSyncMode(BehaviourSyncMode.Continuous)]
    public class SataniaMic : UdonSharpBehaviour
    {
        #region Serialized
        [Header("※必須※ 絶対にNoneにしないでください。")]
        [SerializeField] PlayerVolumeController volumeController;

        [Header("届く距離")]
        [SerializeField] float _NearDistance = 999999f;
        [SerializeField] float _FarDistance = 999999f;

        [Header("表示切り替え用")]
        [SerializeField] Animator _Animator;
        [SerializeField] string _Parameter;
        #endregion

        #region Variables
        [UdonSynced(UdonSyncMode.None), FieldChangeCallback(nameof(Toggle))] bool _Toggle;
 
        VRCPlayerApi _pickupedPlayer;
        VRC_Pickup _pickup;
        #endregion

        #region Callbacks
        public bool Toggle
        {
            get => _Toggle;
            set
            {
                _Toggle = value;

                ChangeVoiceGain(_Toggle);
            }
        }
        #endregion

        #region Voice Func
        private void ChangeVoiceGain(bool toggle)
        {
            if (toggle)
            {
                VRCPlayerApi owner = Networking.GetOwner(gameObject);
                if (owner.IsValid())
                {
                    int id = owner.playerId;

                    if (volumeController.IsLocked(id))
                    {
                        return;
                    }

                    if (toggle)
                    {
                        _pickupedPlayer = owner;

                        volumeController.SetVoiceDistanceNear(id, _NearDistance);
                        volumeController.SetVoiceDistanceFar(id, _FarDistance);

                        DebugLog($"{owner.displayName}がマイクを使用しました。");
                    }

                    volumeController.SetLock(id, toggle);
                }
            }
            else
            {
                int id = _pickupedPlayer.playerId;

                volumeController.SetLock(id, false);
                volumeController.ResetVoiceDistanceNear(id);
                volumeController.ResetVoiceDistanceFar(id);

                DebugLog($"{_pickupedPlayer.displayName}がマイクの使用をやめました。");
                _pickupedPlayer = null;
            }

            if (_Animator != null)
                _Animator.SetBool(_Parameter, toggle);
        }
        #endregion

        #region Player Func
        private int GetLocalPlayerID() => Networking.LocalPlayer.playerId;
        #endregion

        #region Func
        private void ToggleOffMic()
        {
            if (Toggle) 
                Toggle = false;
        }
        #endregion

        #region VRChatFunc
        private void Start()
        {
            _pickup = GetComponent<VRC_Pickup>();
        }

        public override void OnPickupUseDown()
        {
            Toggle = !Toggle;
        }

        public override void OnPickup()
        {
            ToggleOffMic();
        }

        public override void OnDrop()
        {
            ToggleOffMic();
        }
        #endregion

        private void DebugLog(string msg = "", string color = "yellow", string title = nameof(SataniaMic))
        {
            Debug.Log($"[<color={color}>{title}</color>]{msg}");
        }

#if !COMPILER_UDONSHARP && UNITY_EDITOR
        [CustomEditor(typeof(SataniaMic))]
        public class SataniaMicEditor : Editor
        {
            void GetVolumeController()
            {
                SataniaMic mic = target as SataniaMic;
                GameObject gameObject = mic.gameObject;

                Scene scene = gameObject.scene;

                if (mic.volumeController != null) return;
                if (string.IsNullOrEmpty(gameObject.scene.name)) return;

                var objects = scene.GetRootGameObjects();

                foreach (var ob in objects)
                {
                    if (mic.volumeController != null) break;

                    mic.volumeController = ob.GetComponentsInChildren<PlayerVolumeController>(true).FirstOrDefault();
                }

                EditorUtility.SetDirty(mic);
            }

            public override void OnInspectorGUI()
            {
                if (GUILayout.Button($"PlayerVolumeControllerを取得"))
                    GetVolumeController();

                GUILayout.Space(15);

                base.OnInspectorGUI();
            }
        }

#endif
    }
}

