using System;
using UdonSharp;
using UnityEngine;
using VRC.SDK3.Components.Video;
using VRC.SDK3.Video.Components;
using VRC.SDK3.Video.Components.AVPro;
using VRC.SDK3.Video.Components.Base;
using VRC.SDKBase;
using VRC.Udon;

[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MultiVideo : UdonSharpBehaviour
{
	public BaseVRCVideoPlayer _unityVideoPlayer;
	public MultiVideoPlayer Player;
	public MeshRenderer[] monitors;

	public override void OnVideoError(VideoError videoError)
	{
		_unityVideoPlayer.Stop();
	}

	public override void OnVideoReady()
	{
		
	}
	public override void OnVideoStart()
	{
		foreach (var monitor in monitors) monitor.enabled = true;
	}
	public override void OnVideoEnd()
	{
		foreach (var monitor in monitors) monitor.enabled = false;
	}
}
