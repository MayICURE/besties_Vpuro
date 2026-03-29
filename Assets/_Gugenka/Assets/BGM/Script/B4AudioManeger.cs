
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class B4AudioManeger : UdonSharpBehaviour
{
    [SerializeField] private AudioSource[] audioSources;
    float[] _volumes;
    int _sourceLength;
    [System.NonSerialized] public int _newNum, _oldNum;

    private float[] _prevPlayTime;

    public bool isInitialized = false;
    public float fadetime = 2f;
    private float _fadeCount = 0f;
    void Start()
    {
        _sourceLength = audioSources.Length;
        _prevPlayTime = new float[audioSources.Length];
        _volumes = new float[audioSources.Length];
        for (int i = 0; i < _volumes.Length; i++)
        {
            _volumes[i] = audioSources[i].volume;
        }
    }

    void Update()
    {
        if (isInitialized)
        {
            _fadeCount += Time.deltaTime;
            if (_fadeCount > fadetime)
            {
                _prevPlayTime[_oldNum] = audioSources[_oldNum].time;
                audioSources[_oldNum].volume = 0f;
                audioSources[_newNum].volume = _volumes[_newNum];
                audioSources[_oldNum].gameObject.SetActive(false);
                audioSources[_newNum].gameObject.SetActive(true);
                isInitialized = false;
                _fadeCount = 0f;
                return;
            }
            audioSources[_oldNum].volume = Mathf.Lerp(0.0f, _volumes[_oldNum], 1 - (_fadeCount / fadetime));
            audioSources[_newNum].volume = Mathf.Lerp(0.0f, _volumes[_newNum], _fadeCount / fadetime);
        }
    }

    public void Initiate()
    {
        for (int i = 0; i < _sourceLength; i++)
        {
            if (i == _newNum || i == _oldNum) audioSources[i].gameObject.SetActive(true);
            else audioSources[i].gameObject.SetActive(false);

            if (i == _newNum) audioSources[i].time = _prevPlayTime[i];
        }
        if (isInitialized) _fadeCount = fadetime - _fadeCount;
        isInitialized = true;
    }

    //Wait
    public void ChangeInitiate0()
    {
        if (_newNum == 0) return;
        _oldNum = _newNum;
        _newNum = 0;
        Initiate();
    }

    //Live
    public void ChangeInitiate1()
    {
        if (_newNum == 1) return;
        _oldNum = _newNum;
        _newNum = 1;
        Initiate();
    }
}
