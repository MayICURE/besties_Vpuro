
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class AvatarPedestalCheck : UdonSharpBehaviour
{
	public Collider SelfCol;
	public GameObject CheckQuad;
    void Start()
    {
        
    }
	public override void Interact()
	{
		CheckQuad.SetActive(true);
		SelfCol.enabled = false;
	}
	public void Cancel()
	{
		CheckQuad.SetActive(false);
		SelfCol.enabled = true;
	}
}
