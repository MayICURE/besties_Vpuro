
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class AreaMic : UdonSharpBehaviour
{
    // [UdonSynced] private int[] PlayerIds;
    [UdonSynced, FieldChangeCallback(nameof(State))]
    private bool _state = false;
    [SerializeField] private bool defaultOn = false;
    [SerializeField] private int capacity = 40;
    [SerializeField] private float voiceGain = 15.0f;
    [SerializeField] private float voiceDistanceNear = 0.0f;
    [SerializeField] private float voiceDistanceFar = 25.0f;
    [SerializeField] private float voiceVolumetricRadius = 0.0f;
    [SerializeField] private float voiceGain_Loud = 15.0f;
    [SerializeField] private float voiceDistanceNear_Loud = 1000.0f;
    [SerializeField] private float voiceDistanceFar_Loud = 1000000.0f;
    [SerializeField] private float voiceVolumetricRadius_Loud = 1000.0f;
    [SerializeField] private GameObject OnObject = null;
    [SerializeField] private GameObject OffObject = null;
    private int[] PlayerIds;
    private Collider triggerCollider = null;
    public bool State
    {
        set
        {
            _state = value;
            if(OnObject != null) OnObject.SetActive(value);
            if(OffObject != null) OffObject.SetActive(!value);
            triggerCollider.enabled = value;
        }
        get => _state;
    }
    private bool isInited = false;
    void Start()
    {

    }
    void OnEnable()
    {
        if(isInited == false){
            triggerCollider = GetComponent<Collider>();
            triggerCollider.enabled = false;
            PlayerIds = new int[capacity];
            for (int i = 0; i < PlayerIds.Length; i++) {
                PlayerIds[i] = -1;
            }
            if (Networking.IsOwner(gameObject) && defaultOn) {
                State = true;
                RequestSerialization_();
            }
            isInited = true;
        }
        SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.Owner, nameof(RequestSerialization_));
    }
    public override void OnPlayerTriggerEnter(VRCPlayerApi player)
    {
        // if(Networking.IsOwner(gameObject) == false) return;
        for(int i = 0;i < PlayerIds.Length;i++){
            if(PlayerIds[i] == -1){
                PlayerIds[i] = player.playerId;
                break;
            }
        }
        SetVoice();
        // RequestSerialization();
    }
    public override void OnPlayerTriggerExit(VRCPlayerApi player)
    {
        // if(Networking.IsOwner(gameObject) == false) return;
        int myPlayerId = player.playerId;
        for(int i = 0;i < PlayerIds.Length;i++){
            if(PlayerIds[i] == myPlayerId){ 
                PlayerIds[i] = -1;
            }
        }
        SetVoice();
        // RequestSerialization();
    }
    public override void OnDeserialization()
    {
        // SetVoice();
    }
    public void SetVoice()
    {
        // if(State == false) return;
        int playerCount = VRCPlayerApi.GetPlayerCount();
        VRCPlayerApi[] nowPlayers  = new VRCPlayerApi[PlayerIds.Length];
        VRCPlayerApi.GetPlayers(nowPlayers);
        for(int i = 0;i < playerCount;i++){
            if(Utilities.IsValid(nowPlayers[i]) == false) break;
            for(int j = 0;j < PlayerIds.Length;j++){
                if(PlayerIds[j] != -1){
                    if(nowPlayers[i].playerId == PlayerIds[j]){
                        nowPlayers[i].SetVoiceGain(voiceGain_Loud);
                        nowPlayers[i].SetVoiceDistanceNear(voiceDistanceNear_Loud);
                        nowPlayers[i].SetVoiceDistanceFar(voiceDistanceFar_Loud);
                        nowPlayers[i].SetVoiceVolumetricRadius(voiceVolumetricRadius_Loud);
                        break;
                    }
                }
                if(j == PlayerIds.Length - 1){
                    nowPlayers[i].SetVoiceGain(voiceGain);
                    nowPlayers[i].SetVoiceDistanceNear(voiceDistanceNear);
                    nowPlayers[i].SetVoiceDistanceFar(voiceDistanceFar);
                    nowPlayers[i].SetVoiceVolumetricRadius(voiceVolumetricRadius);
                }
            }
        }
        // nowPlayers.playerId = 
        // VRCPlayerApi player = VRCPlayerApi.GetPlayerById(_playerId);
        // if (player == null) return;
        // if (_micOn){
        //     player.SetVoiceGain(15);
        //     player.SetVoiceDistanceNear(100);
        //     player.SetVoiceDistanceFar(100);
        // } else {
        //     player.SetVoiceGain(15);
        //     player.SetVoiceDistanceNear(0);
        //     player.SetVoiceDistanceFar(25);
        // }
    }
    public void CheckPlayerId()
    {
        // if(Networking.IsOwner(gameObject) == false) return;
        bool isChanged = false;
        for(int i = 0;i < PlayerIds.Length;i++){
            if(PlayerIds[i] == -1) continue;
            if(Utilities.IsValid(PlayerIds[i]) == false){
                PlayerIds[i] = -1;
                isChanged = true;
            }
        }
        // if(isChanged == true) RequestSerialization();
        if(isChanged == true) SetVoice();
    }
    public void ToggleState()
    {
        Networking.SetOwner(Networking.LocalPlayer, gameObject);
        State = !State;
        RequestSerialization();
        if (!State) {
            SendCustomNetworkEvent(VRC.Udon.Common.Interfaces.NetworkEventTarget.All, nameof(ResetAll));
        }
    }
    public void ResetAll()
    {
        for (int i = 0; i < PlayerIds.Length; i++) {
            PlayerIds[i] = -1;
        }
    }
    public override void OnPlayerJoined(VRCPlayerApi player)
    {
        if(Networking.IsOwner(gameObject)){
            SendCustomEventDelayedSeconds(nameof(RequestSerialization_), 5f);
        }
        SetVoice();
    }
    public override void OnPlayerLeft(VRCPlayerApi player)
    {
        SendCustomEventDelayedSeconds(nameof(CheckPlayerId), 5f);
    }
    public override void OnPlayerRespawn(VRCPlayerApi player)
    {
        // if(Networking.IsOwner(gameObject) == false) return;
        int myPlayerId = player.playerId;
        if(myPlayerId == -1) return;
        for(int i = 0;i < PlayerIds.Length;i++){
            if(PlayerIds[i] == myPlayerId){ 
                PlayerIds[i] = -1;
            }
        }
        // RequestSerialization();
        SetVoice();
    }
    public void RequestSerialization_()
    {
        RequestSerialization();
    }
}
