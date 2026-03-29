
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class B4AudioManegerTimelineEvent : UdonSharpBehaviour
{
    [SerializeField] private B4AudioManeger target;

    [SerializeField] private bool setIndex0;
    [SerializeField] private bool setIndex1;

    private void OnEnable()
    {
        if (setIndex0)
        {
            target.ChangeInitiate0();
            return;
        }
        else if (setIndex1)
        {
            target.ChangeInitiate1();
            return;
        }
    }
}
