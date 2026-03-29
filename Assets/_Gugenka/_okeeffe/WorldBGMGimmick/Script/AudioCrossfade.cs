
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class AudioCrossfade : UdonSharpBehaviour
{
    public AudioSource[] Sources;
    private int sourcelength;
    private int newNum, oldNum;

    public float MaxVolume = 0.3f;
    private float[] prevPlayTime;

    public bool isInitialized = false;
    public float fadetime = 2f;
    private float time = 0f;

    void Start()
    {
        sourcelength = Sources.Length;//AudioSouce”‚ðŠi”[
        prevPlayTime = new float[Sources.Length];

    }
    void Update()
    {
        if(isInitialized)
        {
            time += Time.deltaTime;
            if(time > fadetime)
            {
                prevPlayTime[oldNum] = Sources[oldNum].time;
                Sources[oldNum].volume = 0f;
                Sources[newNum].volume = MaxVolume;
                Sources[oldNum].gameObject.SetActive(false);
                Sources[newNum].gameObject.SetActive(true);
                isInitialized = false;
                time = 0f;
                //this.gameObject.SetActive(false);
                return;
            }
            //Sources[oldNum].volume = 1 - (time / fadetime);
            //Sources[newNum].volume = time / fadetime;
            Sources[oldNum].volume = Mathf.Lerp(0.0f, MaxVolume, 1 - (time / fadetime));
            Sources[newNum].volume = Mathf.Lerp(0.0f, MaxVolume, time / fadetime);
        }
    }
    public void Initiate()
    {
        for(int i = 0; i < sourcelength; i++)
        {
            if(i == newNum || i == oldNum)Sources[i].gameObject.SetActive(true);
            else Sources[i].gameObject.SetActive(false);

            if (i == newNum) Sources[i].time = prevPlayTime[i];
        }
        if(isInitialized)time = fadetime - time;
        isInitialized = true;
    }

    public void ChangeInitiate0()
    {
        oldNum = newNum;
        newNum = 0;
        Initiate();
    }
    public void ChangeInitiate1()
    {
        oldNum = newNum;
        newNum = 1;
        Initiate();
    }
    public void ChangeInitiate2()
    {
        oldNum = newNum;
        newNum = 2;
        Initiate();
    }
}
