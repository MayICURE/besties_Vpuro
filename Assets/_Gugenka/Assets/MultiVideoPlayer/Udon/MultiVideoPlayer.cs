using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using VRC.SDK3.Components.Video;
using VRC.SDK3.Video.Components;
using VRC.SDK3.Video.Components.AVPro;
using VRC.SDK3.Video.Components.Base;
using VRC.SDKBase;
using VRC.Udon;
using UnityEngine.Playables;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MultiVideoPlayer : UdonSharpBehaviour
{
	[Header("Common")]
	public MultiVideoPlayerManager manager;
	public BaseVRCVideoPlayer[] TargetPlayer;
	public VRCUrl[] TargetURL;

	public float MaxWaitTime = 10.0f;
	float WaitTime = 0.0f;
	bool IsWaitLoading;

	bool[] LoadChecker;
	int CurrentLoading = 0;

	int ErrorCount = 0;

	bool StartLoading;
	[System.NonSerialized] public bool IsLoadEnd;
	bool StartPlaying;

	[System.NonSerialized] public float PlayOffset;

	[Header("DebugText")]
	public bool UseDebug;
	public Slider WaitTimeSlider;
	public Text CurrentLoadingText;


	public float ManualOffset = 0f;

	public bool isLangChange = false;
	public VRCUrl[] EngURL;

	public bool isLoopMov = false;
	float syncBaseTime;
	DateTime baseDateTime = new DateTime(2023, 12, 1, 0, 0, 0);


	void Start()
	{
		if(TargetPlayer.Length == 0) return;
		WaitTimeSlider.maxValue = MaxWaitTime;
		LoadChecker = new bool[TargetPlayer.Length]; //現在何番目の動画を読み込んでいるかの情報を格納する配列
	}

	private void Update()
	{
		if (TargetPlayer.Length == 0) return;
		if (StartLoading) MultiVideoLoading();
		if (IsLoadEnd && StartPlaying) MultiVideoPlaying();

		if (UseDebug)
		{
			WaitTimeSlider.value = WaitTime;
			CurrentLoadingText.text = "NowLoadingVideo:" + (CurrentLoading + 1).ToString();
		}
	}

	void MultiVideoPlaying()
	{
		if (TargetPlayer.Length == 0) return;
		if(!isLoopMov) manager.SetVideoTime();
		else syncBaseTime = (float)(Networking.GetNetworkDateTime() - baseDateTime).TotalSeconds;
		for (int i = 0; i < TargetPlayer.Length; i++)
		{
			if(TargetPlayer[i] == null)return;
			if (TargetPlayer[i].IsReady)
			{
				if (isLoopMov) TargetPlayer[i].SetTime(Mathf.Repeat(syncBaseTime, TargetPlayer[i].GetDuration()));
				else TargetPlayer[i].SetTime(Mathf.Max(0f + PlayOffset + ManualOffset, 0f));
				TargetPlayer[i].Play();
			}
		}

		StartPlaying = false;
	}

	void MultiVideoLoading()
	{
		if (TargetPlayer.Length == 0) return;
		if (CurrentLoading == TargetPlayer.Length) //全ての読み込みが完了した場合の処理
		{
			IsLoadEnd = true;
			CurrentLoading = 0;
			StartLoading = false;
			manager.ReceiveEndLoading();
			return;
		}

		if (IsWaitLoading == true) WaitTime += Time.deltaTime; //読み込み毎に指定秒数のウェイトを挟む

		if (LoadChecker[CurrentLoading] == false) //0番(URL)から読み込みを開始 
		{

			if(isLangChange && TimeZoneInfo.Local.Id != "Tokyo Standard Time") TargetPlayer[CurrentLoading].LoadURL(EngURL[CurrentLoading]);
			else TargetPlayer[CurrentLoading].LoadURL(TargetURL[CurrentLoading]); 
			LoadChecker[CurrentLoading] = true;

			WaitTime = 0f;
			IsWaitLoading = true;
		}

		if (WaitTime >= MaxWaitTime)
		{
			if (TargetPlayer[CurrentLoading]==null) //Depthkitエラー
			{
				IsWaitLoading = false;
				WaitTime = 0f;
				CurrentLoading += 1;
				ErrorCount = 0;
				return;
			}
			if (TargetPlayer[CurrentLoading].IsReady == false && ErrorCount >= 10) //複数回エラーを返した場合はその動画をスキップ
			{
				IsWaitLoading = false;
				WaitTime = 0f;
				CurrentLoading += 1;
				ErrorCount = 0;
				return;
			}

			if (TargetPlayer[CurrentLoading].IsReady == true) //正常にロードが行われた場合は次のURLのロードに進む
			{
				IsWaitLoading = false;
				WaitTime = 0f;
				LoadChecker[CurrentLoading] = false;
				CurrentLoading += 1;
			}
			else //ロードに失敗した場合はLoadCheckをFalseに戻して再ロード エラーカウントを増やす
			{
				LoadChecker[CurrentLoading] = false;
				ErrorCount += 1;

				IsWaitLoading = false;
				WaitTime = 0f;
			}
		}
	}
	public void StartVideoLoading()
	{
		if (TargetPlayer.Length == 0)
		{
			IsLoadEnd = true;
			CurrentLoading = 0;
			StartLoading = false;
			manager.ReceiveEndLoading();
			return;
		}
		StartLoading = true;
	}

	public void StartVideoPlaying()
	{
		StartPlaying = true;
	}
	public void PauseAllVideo()
	{
		if (TargetPlayer.Length == 0) return;
		for (int i = 0; i < TargetPlayer.Length; i++)
		{
			if (TargetPlayer[i] == null) return;
			if (TargetPlayer[i].IsReady) TargetPlayer[i].Pause();
		}
	}
}
