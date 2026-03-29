//Copyright (c) 2024 SataniaShopping
//Released under the VN3 license
//https://drive.google.com/file/d/1REq1aSBODwCZ9eyzq3Es-pjlv-a7K-4l/view?usp=drive_link

using satania.behaviour;
using VRC.SDK3.Data;
using VRC.SDKBase;
using UnityEngine;

namespace com.satania.player.volume
{
    /// <summary>
    /// ローカル動作
    /// </summary>
    public class PlayerVolumeController : SataniaNonSyncBehaviour
    {
        private void DebugLog(string msg = "", string color = "yellow", string title = nameof(PlayerVolumeController))
        {
            Debug.Log($"[<color={color}>{title}</color>]{msg}");
        }

        #region Variables
        [Header("マイクのゲイン値 | 範囲[0-24] デフォルト[15]")]
        [SerializeField] float VoiceGain = 15.0f;

        [Header("マイク音量が下がり始める距離 | 範囲[0 - 1000000] デフォルト[0]")]
        [SerializeField] float VoiceDistanceNear = 0.0f;

        [Header("マイクの音が届く最大距離 | 範囲[0 - 1000000] デフォルト[25]")]
        [SerializeField] float VoiceDistanceFar = 25.0f;

        [Header("マイクの音源の大きさ | 範囲[0 - 1000] デフォルト[0]")]
        [SerializeField] float VoiceVolumetricRadius = 0.0f;

        [Header("マイクのローパスフィルター | デフォルト[ON]")]
        [SerializeField] bool VoiceLowPass = true;

        [Header("アバター音量のゲイン値 | 範囲[0 - 10] デフォルト[10]")]
        [SerializeField] float AvatarAudioGain = 10.0f;

        [Header("アバターの音声が聞こえる最大距離 | 範囲[0 - 40] デフォルト[40]")]
        [SerializeField] float AvatarAudioFarRadius = 40.0f;

        [Header("アバターの音声が聞こえ始める距離 | 範囲[0 - 40] デフォルト[40]")]
        [SerializeField] float AvatarAudioNearRadius = 40.0f;

        [Header("アバターの音声が聞こえる中心点の大きさ | 範囲[0 - 40] デフォルト[40]")]
        [SerializeField] float AvatarAudioVolmetricRadius = 40.0f;

        [Header("アバターオーディオの空間化 | デフォルト[OFF]")]
        [SerializeField] bool AvatarAudioForceSpatial = false;

        [Header("オーディオソースのカスタムカーブの有効化 | デフォルト[ON]")]
        [SerializeField] bool AvatarAudioCustomCurve = true;

        private DataDictionary _VoiceGains = new DataDictionary();
        private DataDictionary _VoiceDistanceNears = new DataDictionary();
        private DataDictionary _VoiceDistanceFars = new DataDictionary();
        private DataDictionary _VoiceVolumetricRadius = new DataDictionary();
        private DataDictionary _VoiceLowpasses = new DataDictionary();

        private DataDictionary _Lock = new DataDictionary();

        private DataDictionary _AvatarAudioGain = new DataDictionary();
        private DataDictionary _AvatarAudioFarRadius = new DataDictionary();
        private DataDictionary _AvatarAudioNearRadius = new DataDictionary();
        private DataDictionary _AvatarAudioVolumetricRadius = new DataDictionary();
        private DataDictionary _AvatarAudioForceSpatial = new DataDictionary();
        private DataDictionary _AvatarAudioCustomCurve = new DataDictionary();
        #endregion

        #region VRCPlayerApi Func
        VRCPlayerApi[] GetAllPlayers()
        {
            VRCPlayerApi[] players = new VRCPlayerApi[VRCPlayerApi.GetPlayerCount()];
            VRCPlayerApi.GetPlayers(players);
            return players;
        }
        #endregion

        #region Dictionary Func
        private int GetIndexFromKey(DataDictionary dic, DataToken key)
        {
            var keys = dic.GetKeys();
            int ret = keys.IndexOf(key);

            return ret;
        }
        private void AddDictionary(DataDictionary dic, int key, DataToken value)
        {
            int index = GetIndexFromKey(dic, key);
            if (index == -1)
                dic.Add(key, value);
        }
        private void RemoveDictionary(DataDictionary dic, int key)
        {
            int index = GetIndexFromKey(dic, key);
            if (index != -1)
                dic.Remove(key);
        }
        private void AddDictionaries(int _id)
        {
            SetDictionary(_VoiceGains, _id, VoiceGain);
            SetDictionary(_VoiceDistanceNears, _id, VoiceDistanceNear);
            SetDictionary(_VoiceDistanceFars, _id, VoiceDistanceFar);
            SetDictionary(_VoiceVolumetricRadius, _id, VoiceVolumetricRadius);
            SetDictionary(_VoiceLowpasses, _id, VoiceLowPass);

            SetDictionary(_AvatarAudioGain, _id, AvatarAudioGain);
            SetDictionary(_AvatarAudioFarRadius, _id, AvatarAudioFarRadius);
            SetDictionary(_AvatarAudioNearRadius, _id, AvatarAudioNearRadius);
            SetDictionary(_AvatarAudioVolumetricRadius, _id, AvatarAudioVolmetricRadius);
            SetDictionary(_AvatarAudioForceSpatial, _id, AvatarAudioForceSpatial);
            SetDictionary(_AvatarAudioCustomCurve, _id, AvatarAudioCustomCurve);

            SetDictionary(_Lock, _id, false);
        }
        private void RemoveDictionaries(VRCPlayerApi player)
        {
            int _id = player.playerId;

            RemoveDictionary(_VoiceGains, _id);
            RemoveDictionary(_VoiceDistanceNears, _id);
            RemoveDictionary(_VoiceDistanceFars, _id);
            RemoveDictionary(_VoiceVolumetricRadius, _id);
            RemoveDictionary(_VoiceLowpasses, _id);

            RemoveDictionary(_AvatarAudioGain, _id);
            RemoveDictionary(_AvatarAudioFarRadius, _id);
            RemoveDictionary(_AvatarAudioNearRadius, _id);
            RemoveDictionary(_AvatarAudioVolumetricRadius, _id);
            RemoveDictionary(_AvatarAudioForceSpatial, _id);
            RemoveDictionary(_AvatarAudioCustomCurve, _id);

            RemoveDictionary(_Lock, _id);
        }
        private void SetDictionary(DataDictionary dic, int key, DataToken value)
        {
            int index = GetIndexFromKey(dic, key);
            if (index == -1)
                AddDictionary(dic, key, value);
            else
                dic[key] = value;
        }
        private void InitializeDictionary(VRCPlayerApi player)
        {
            if (!player.isLocal)
                return;

            var players = GetAllPlayers();
            foreach (var plr in players)
            {
                if (plr == null)
                    continue;

                if (!plr.IsValid())
                    continue;

                AddDictionaries(plr.playerId);
            }
        }
        #endregion

        #region GetValue Func
        public float GetVoiceGain(int playerid)
        {
            float ret = VoiceGain;
            if (_VoiceGains.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetVoiceDistanceNear(int playerid)
        {
            float ret = VoiceDistanceNear;
            if (_VoiceDistanceNears.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetVoiceDistanceFar(int playerid)
        {
            float ret = VoiceDistanceFar;
            if (_VoiceDistanceFars.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetVoiceVolumetricRadius(int playerid)
        {
            float ret = VoiceVolumetricRadius;
            if (_VoiceVolumetricRadius.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public bool GetVoiceLowpass(int playerid)
        {
            bool ret = VoiceLowPass;
            if (_VoiceLowpasses.TryGetValue(playerid, out DataToken value))
                ret = value.Boolean;

            return ret;
        }
        public float GetAvatarAudioGain(int playerid)
        {
            float ret = AvatarAudioGain;
            if (_AvatarAudioGain.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetAvatarAudioFarRadius(int playerid)
        {
            float ret = AvatarAudioFarRadius;
            if (_AvatarAudioFarRadius.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetAvatarAudioNearRadius(int playerid)
        {
            float ret = AvatarAudioNearRadius;
            if (_AvatarAudioNearRadius.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public float GetAvatarAudioVolumetricRadius(int playerid)
        {
            float ret = AvatarAudioVolmetricRadius;
            if (_AvatarAudioVolumetricRadius.TryGetValue(playerid, out DataToken value))
                ret = value.Float;

            return ret;
        }
        public bool GetAvatarAudioForceSpatial(int playerid)
        {
            bool ret = AvatarAudioForceSpatial;
            if (_AvatarAudioForceSpatial.TryGetValue(playerid, out DataToken value))
                ret = value.Boolean;

            return ret;
        }
        public bool GetAvatarAudioCustomCurve(int playerid)
        {
            bool ret = AvatarAudioCustomCurve;
            if (_AvatarAudioCustomCurve.TryGetValue(playerid, out DataToken value))
                ret = value.Boolean;

            return ret;
        }
        #endregion

        #region Lock
        public void SetLock(int playerid, bool toggle)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                SetDictionary(_Lock, playerid, toggle);

                DebugLog($"{player.displayName}'s Lock -> {toggle}");
            }
        }
        public bool IsLocked(int playerid)
        {
            bool ret = false;
            if (_Lock.TryGetValue(playerid, out DataToken value))
                ret = value.Boolean;

            return ret;
        }
        #endregion

        #region Player Voice Func
        public void SetVoiceGain(int playerid, float gain) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                if (IsLocked(playerid))
                    return;

                SetDictionary(_VoiceGains, playerid, gain);
                player.SetVoiceGain(gain);
            }
        }
        public void SetVoiceDistanceNear(int playerid, float near)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                if (IsLocked(playerid))
                    return;

                SetDictionary(_VoiceDistanceNears, playerid, near);
                player.SetVoiceDistanceNear(near);
            }
        }

        public void SetVoiceDistanceFar(int playerid, float far) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                if (IsLocked(playerid))
                    return;

                SetDictionary(_VoiceDistanceFars, playerid, far);
                player.SetVoiceDistanceFar(far);
            }
        }
        public void SetVoiceVolumetricRadius(int playerid, float radius) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                if (IsLocked(playerid))
                    return;

                SetDictionary(_VoiceVolumetricRadius, playerid, radius);
                player.SetVoiceVolumetricRadius(radius);
            }
        }
        public void SetVoiceLowpass(int playerid, bool lowpass) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);

            if (player != null)
            {
                if (IsLocked(playerid))
                    return;

                SetDictionary(_VoiceLowpasses, playerid, lowpass);
                player.SetVoiceLowpass(lowpass);
            }
        }
        #endregion

        #region Avatar Audio Func
        public void SetAvatarAudioGain(int playerid, float gain)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null) 
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioGain, playerid, gain);
            player.SetAvatarAudioGain(gain);
        }
        public void SetAvatarAudioFarRadius(int playerid, float radius)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null)
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioFarRadius, playerid, radius);
            player.SetAvatarAudioFarRadius(radius);
        }
        public void SetAvatarAudioNearRadius(int playerid, float radius)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null)
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioNearRadius, playerid, radius);
            player.SetAvatarAudioNearRadius(radius);
        }
        public void SetAvatarAudioVolumetricRadius(int playerid, float radius) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null)
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioVolumetricRadius, playerid, radius);
            player.SetAvatarAudioVolumetricRadius(radius);
        }
        public void SetAvatarAudioForceSpatial(int playerid, bool spatial) 
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null)
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioForceSpatial, playerid, spatial);
            player.SetAvatarAudioForceSpatial(spatial);
        }
        public void SetAvatarAudioCustomCurve(int playerid, bool useCustomCurve)
        {
            VRCPlayerApi player = VRCPlayerApi.GetPlayerById(playerid);
            if (player == null)
                return;

            if (IsLocked(playerid))
                return;

            SetDictionary(_AvatarAudioCustomCurve, playerid, useCustomCurve);
            player.SetAvatarAudioCustomCurve(useCustomCurve);
        }
        #endregion

        #region Reset Func
        public void ResetVoiceGain(int playerid) => SetVoiceGain(playerid, VoiceGain);
        public void ResetVoiceDistanceNear(int playerid) => SetVoiceDistanceNear(playerid, VoiceDistanceNear);
        public void ResetVoiceDistanceFar(int playerid) => SetVoiceDistanceFar(playerid, VoiceDistanceFar);
        public void ResetVoiceVolumetricRadius(int playerid) => SetVoiceVolumetricRadius(playerid, VoiceVolumetricRadius);
        public void ResetVoiceLowpass(int playerid) => SetVoiceLowpass(playerid, VoiceLowPass);
        public void ResetPlayerVoice(int playerid)
        {
            ResetVoiceGain(playerid);
            ResetVoiceDistanceNear(playerid);
            ResetVoiceDistanceFar(playerid);
            ResetVoiceVolumetricRadius(playerid);
            ResetVoiceLowpass(playerid);
        }

        public void ResetAvatarAudioGain(int playerid) => SetAvatarAudioGain(playerid, AvatarAudioGain);
        public void ResetAvatarAudioFarRadius(int playerid) => SetAvatarAudioFarRadius(playerid, AvatarAudioFarRadius);
        public void ResetAvatarAudioNearRadius(int playerid) => SetAvatarAudioNearRadius(playerid, AvatarAudioNearRadius);
        public void ResetAvatarAudioVolumetricRadius(int playerid) => SetAvatarAudioVolumetricRadius(playerid, AvatarAudioVolmetricRadius);
        public void ResetAvatarAudioForceSpatial(int playerid) => SetAvatarAudioForceSpatial(playerid, AvatarAudioForceSpatial);
        public void ResetAvatarAudioCustomCurve(int playerid) => SetAvatarAudioCustomCurve(playerid, AvatarAudioCustomCurve);
        public void ResetAvatarAudio(int playerid)
        {
            ResetAvatarAudioGain(playerid);
            ResetAvatarAudioFarRadius(playerid);
            ResetAvatarAudioNearRadius(playerid);
            ResetAvatarAudioVolumetricRadius(playerid);
            ResetAvatarAudioForceSpatial(playerid);
            ResetAvatarAudioCustomCurve(playerid);
        }
        #endregion

        #region VRChat Func
        public override void OnPlayerJoined(VRCPlayerApi player)
        {
            if (player.isLocal)
                InitializeDictionary(player);
            else
                AddDictionaries(player.playerId);
        }

        public override void OnPlayerLeft(VRCPlayerApi player)
        {
            //自身が抜けたときはスルー
            if (!player.isLocal)
                RemoveDictionaries(player);
        }
        #endregion
    }
}
