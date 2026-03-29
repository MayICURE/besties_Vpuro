using System;
using UdonSharp;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Playables;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MultiVideoPlayerManager : UdonSharpBehaviour
{
	[Header("Timeline")]
	[SerializeField] PlayableDirector rootTimeline;
	[Header("Timeline StartDate")]
	public string[] timelineStartDate;

	DateTime[] jstEventDate;
	DateTime[] jstEventDateUTC;
	

	[Header("rootTimeline sec")]
	[SerializeField] float[] videoStartTimings;
	[Header("Shortest Video Duration")]
	[SerializeField] float[] videoDurations;
	

	[Header("VideoPlayer")]
	[SerializeField] GameObject NoticeLoadingVideo;
	[SerializeField] MultiVideoPlayer[] VideoManagers;

	[SerializeField] GameObject EndObject;


	[Header("Button")]
	[SerializeField] bool isEventEndButtonChange = false;
	[SerializeField] bool isDisableButtonReset = false;
	bool isButton = false;
	bool isButtonPressed = false;
	[SerializeField] GameObject buttonObj;
	TimeSpan buttonOffset;
	public double buttonStartTime = 0;
	


	[UdonSynced, FieldChangeCallback(nameof(SyncTime))]
	double _syncTime;

	public double SyncTime
	{
		get => _syncTime;
		set
		{
			//二人以上いるインスタンスで実行される
			Debug.Log($"SyncTimeSet{value.ToString()}");
			_syncTime = value;
			if(isButton && _syncTime != 0)
			{
				ButtonCalled();
			}
		}
	}

	//[Header("Debug")]
	int eventProgress = 0;
	bool[] isEndLoadings;
	bool[] isStartedVideos;
	int LoadingIndex = 0;
	int LoadingStartIndex = 0;
	bool isLoadStartTimingChecked = false;
	int CurrentIndex = -1;
	bool loadingNextEvent = false;

	int utcOffset = -9;

	bool _isTimelinePlaying;
	bool _isEventEnd;

	bool LoadedAllVideo = false;
	bool LoadStart = false;

	float timelineDuration;

	DateTime localTime;
	DateTime localToUTCTime;
	TimeSpan ts;


	[Header("Countdown")]
	[SerializeField] bool isCountdown = false;
	[SerializeField] GameObject countBase;
	[SerializeField] Text countText;
	[SerializeField] float appearTeleporterTime = -60f;
	[SerializeField] GameObject teleporterObject;
	DateTime countDownDT;
	bool isCountEnd;
	bool setTeleporter;


	[Header("LoopMovie")]
	[SerializeField] bool isLoopMov = false;
	[SerializeField] MultiVideoPlayer LoopMovPlayers;
	bool isLoopMovsLoaded = false;


	bool isInit = false;

	bool isNoVideo = false;


	private void Start()
	{
		isInit = true;
		//variable init
		if (VideoManagers.Length == 0) isNoVideo = true;
		else
		{
			isEndLoadings = new bool[VideoManagers.Length];
			isStartedVideos = new bool[VideoManagers.Length];
		}

		timelineDuration = (float)rootTimeline.duration;
		jstEventDate = new DateTime[timelineStartDate.Length];
		jstEventDateUTC = new DateTime[timelineStartDate.Length];

		DateTime slocalTime = Networking.GetNetworkDateTime();
		DateTime slocalToUTCTime = System.TimeZoneInfo.ConvertTimeToUtc(slocalTime);


		for (int i = 0; i < jstEventDate.Length; i++)
		{
			string[] jstEventTimesArr = timelineStartDate[i].Split(',');
			jstEventDate[i] = new DateTime(int.Parse(jstEventTimesArr[0]), int.Parse(jstEventTimesArr[1]), int.Parse(jstEventTimesArr[2]), int.Parse(jstEventTimesArr[3]), int.Parse(jstEventTimesArr[4]), int.Parse(jstEventTimesArr[5]));
			jstEventDateUTC[i] = jstEventDate[i].AddHours(utcOffset);
		}
		if (!isButton)
		{
			for (int i = 0; i < jstEventDate.Length; i++)
			{
				TimeSpan tempSpan = slocalToUTCTime - jstEventDateUTC[i];
				if (tempSpan.TotalSeconds >= timelineDuration) eventProgress++;
				else break;
			}
			if (eventProgress >= jstEventDate.Length)
			{
				if(isEventEndButtonChange)
				{
					isButton = true;
					if(SyncTime == 0) buttonObj.SetActive(true);
					eventProgress = 0;
				}
				else
				{
					_isEventEnd = true;
					EndObject.SetActive(true);
					return;
				}
			}
		}

		TimeSpan sts = slocalToUTCTime - jstEventDateUTC[eventProgress];


		//入場時点でテレポーターの出現時刻を過ぎていたらテレポーターを出現させる
		if (isCountdown && sts.TotalSeconds >= appearTeleporterTime)
		{
			setTeleporter = true;
			teleporterObject.SetActive(true);
			isCountEnd = true;
			countBase.gameObject.SetActive(false);
		}

		if (isButton)
		{
			sts = TimeSpan.Zero;
			if (SyncTime != 0) sts += TimeSpan.FromSeconds(SyncTime);
		}

		if (isLoopMov) LoopMovPlayers.StartVideoLoading();
		else
		{
			isLoopMovsLoaded = true;
			if(!isNoVideo) VideoManagers[LoadingIndex].StartVideoLoading();
		}

		if (sts.TotalSeconds > 0) //ライブ部分再生途中だった場合は動画のロードを即開始、オフセットを適用してライブ部分のタイムラインを再生開始
		{
			for (int i = 0; i < videoStartTimings.Length; i++)
			{
				if (sts.TotalSeconds - videoStartTimings[i] >= 0)
				{
					if (sts.TotalSeconds - videoStartTimings[i] > videoDurations[i])
					{
						if (i + 1 < videoStartTimings.Length)
						{
							LoadingIndex = i + 1;
							LoadingStartIndex = i + 1;
							CurrentIndex = i + 1;
						}
						continue;
					}
					else
					{
						LoadingIndex = i;
						LoadingStartIndex = i;
						CurrentIndex = i;
					}
				}
				else break;
			}

			rootTimeline.initialTime = sts.TotalSeconds;
			rootTimeline.gameObject.SetActive(true);
			rootTimeline.Play();
			_isTimelinePlaying = true;
		}
	}


	private void Update()
	{
		if (!isInit)return;
		if (_isEventEnd)
		{
			return;
		}
		if (eventProgress >= jstEventDateUTC.Length) return;
		else
		{
			//PCのローカル時間をUTC時間に変換
			//DateTime 
			localTime = System.DateTime.Now;
			//DateTime 
			localToUTCTime = System.TimeZoneInfo.ConvertTimeToUtc(localTime);

			//TimeSpan 
			ts = localToUTCTime - jstEventDateUTC[eventProgress];

			if(isCountdown)
			{
				if(!isCountEnd)
				{
					countDownDT = jstEventDateUTC[eventProgress].AddSeconds(appearTeleporterTime);
					TimeSpan count = countDownDT - localToUTCTime;
					int hourWithDay = 24 * count.Days + count.Hours;
					countText.text = hourWithDay.ToString() + count.ToString(@"\:mm\:ss");
				}
				//テレポーターの出現時刻を過ぎたらテレポーターを出現させる
				if (!setTeleporter)
				{
					if (ts.TotalSeconds >= appearTeleporterTime)
					{
						setTeleporter = true;
						teleporterObject.SetActive(true);
						isCountEnd = true;
						countBase.gameObject.SetActive(false);
					}
				}
			}

			if (isButton)
			{
				//ts(現在時刻 - イベント開始時刻) + buttonOffset(イベント開始時刻 - ボタンを押した時刻) = 現在時刻 - ボタンを押した時刻
				ts += buttonOffset;
				if (!isButtonPressed) return;
			}

			//開始時刻を過ぎたら再生を開始する
			if (!_isTimelinePlaying && !_isEventEnd)
			{
				if (ts.TotalSeconds >= 0)
				{
					rootTimeline.initialTime = 0;
					rootTimeline.gameObject.SetActive(true);
					rootTimeline.Play();
					_isTimelinePlaying = true;
					//CurrentIndex = 0;
					Debug.Log($"NormalStart{ts.ToString()}");
				}
			}

			for (int i = 0; i < videoStartTimings.Length; i++)
			{
				if (ts.TotalSeconds - videoStartTimings[i] >= 0)
				{
					if (ts.TotalSeconds - videoStartTimings[i] > videoDurations[i]) continue;
					else CurrentIndex = i;
				}
				else break;
			}

			//タイムラインの再生中
			if (_isTimelinePlaying && !_isEventEnd && !isNoVideo)
			{
				if(CurrentIndex == -1)return;
				//動画が再生されていないかつ遅れてロードが完了した場合に、現在のタイムラインの再生時間をセットして動画を再生開始
				if (isEndLoadings[CurrentIndex] && !isStartedVideos[CurrentIndex])
				{
					if (ts.TotalSeconds - videoStartTimings[CurrentIndex] < videoDurations[CurrentIndex])
					{
						//VideoManagers[CurrentIndex].PlayOffset = (float)(rootTimeline.time - videoStartTimings[CurrentIndex]);
						VideoManagers[CurrentIndex].StartVideoPlaying();
						isStartedVideos[CurrentIndex] = true;
						Debug.Log($"LateJoin：{(rootTimeline.time - videoStartTimings[CurrentIndex]).ToString()}");
						NoticeLoadingVideo.SetActive(false);
						return;
					}
				}

				if (ts.TotalSeconds >= timelineDuration)
				{
					eventProgress++;
					if(isButton)
					{
						isButtonPressed = false;
						if(isDisableButtonReset) buttonObj.SetActive(true);
					}
					_isTimelinePlaying = false;
					CurrentIndex = -1;
					for (int i = 0; i < isStartedVideos.Length; i++)
					{
						isStartedVideos[i] = false;
					}
				}
				if (eventProgress >= jstEventDate.Length && !isEventEndButtonChange)
				{
					_isEventEnd = true;
					EndObject.SetActive(true);
					return;
				}
			}
		}
	}

	public void ReceiveEndLoading()
	{

		if (LoadingIndex >= VideoManagers.Length) LoadingIndex = 0;

		if (!isLoopMovsLoaded) //ループ動画読み込み完了時のみ
		{
			isLoopMovsLoaded = true;
			LoopMovPlayers.StartVideoPlaying();
			if (!isNoVideo) VideoManagers[LoadingIndex].StartVideoLoading();
		}
		isEndLoadings[LoadingIndex] = true;
		Debug.Log("Load1");

		if (loadingNextEvent)//途中入場でスキップした分の動画を次回再生用にロード
		{
			LoadingIndex++;
			if (LoadingIndex < LoadingStartIndex)
			{
				if (!isNoVideo)
				{
					if(!isEndLoadings[LoadingIndex]) VideoManagers[LoadingIndex].StartVideoLoading();
					else 
					{
						Debug.Log("LoadedVideo");
						ReceiveEndLoading();
					}
				}
			}
			else
			{
				LoadedAllVideo = true;
				LoadStart = false;
			}
			return;
		}

		LoadingIndex++;
		if (LoadingIndex == VideoManagers.Length)
		{
			if (LoadingStartIndex != 0)
			{
				loadingNextEvent = true;
				LoadingIndex = 0;
				if (!isNoVideo) VideoManagers[LoadingIndex].StartVideoLoading();
				return;
			}

			LoadedAllVideo = true;
			LoadStart = false;
		}
		else
		{
			if (!isNoVideo) VideoManagers[LoadingIndex].StartVideoLoading();
		}
		return;
	}
	public void InteractCall()
	{
		if(isDisableButtonReset && _isTimelinePlaying) return;
		DateTime localTime = System.DateTime.Now;
		DateTime localToUTCTime = System.TimeZoneInfo.ConvertTimeToUtc(localTime);

		buttonOffset = jstEventDateUTC[0] - localToUTCTime;
		Debug.Log($"Interact：{buttonOffset.ToString()}");
#if UNITY_EDITOR
#else
		if (!Networking.LocalPlayer.IsOwner(this.gameObject))Networking.SetOwner(Networking.LocalPlayer, this.gameObject);
#endif
		SyncTime = buttonOffset.TotalSeconds + buttonStartTime;
		RequestSerialization();
		Debug.Log($"SyncTime：{SyncTime.ToString()}");
#if UNITY_EDITOR
		ButtonCalled();
#else
		if (VRCPlayerApi.GetPlayerCount() == 1) ButtonCalled();		
#endif

	}
	private void ButtonCalled()
	{
		//再度再生するためにリセット
		rootTimeline.Stop();
		if(CurrentIndex != -1) VideoManagers[CurrentIndex].PauseAllVideo();
		eventProgress = 0;
		CurrentIndex = -1;
		if (!isNoVideo)
		{
			for (int i = 0; i < isStartedVideos.Length; i++)
			{
				isStartedVideos[i] = false;
			}
		}
		//
		isButtonPressed = true;
		if(isDisableButtonReset) buttonObj.SetActive(false);
		buttonOffset = TimeSpan.FromSeconds(SyncTime);
		//Timeline同期
		localTime = System.DateTime.Now;
		localToUTCTime = System.TimeZoneInfo.ConvertTimeToUtc(localTime);
		ts = localToUTCTime - jstEventDateUTC[eventProgress];
		rootTimeline.initialTime = (ts + buttonOffset).TotalSeconds;
		rootTimeline.gameObject.SetActive(true);
		rootTimeline.Play();
		_isTimelinePlaying = true;
		Debug.Log($"buttonOffset：{buttonOffset.TotalSeconds.ToString()}");
	}
	public void SetVideoTime()
	{
		VideoManagers[CurrentIndex].PlayOffset = (float)(rootTimeline.time - videoStartTimings[CurrentIndex]);
	}
}

