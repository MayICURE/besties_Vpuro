
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class UdonGI : UdonSharpBehaviour
{
    public MeshRenderer taregetRenderer;
    private float emissionInterval;
    private float intervalTime;
    void Start()
    {
        taregetRenderer = GetComponent<MeshRenderer>();
    }

    void Update() 
    {
        RendererExtensions.UpdateGIMaterials(taregetRenderer);
    }
}
