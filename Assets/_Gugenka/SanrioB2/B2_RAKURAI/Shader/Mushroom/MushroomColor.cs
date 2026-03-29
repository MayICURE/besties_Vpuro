
using UdonSharp;
using UnityEngine;
using VRC.SDKBase;
using VRC.Udon;

public class MushroomColor : UdonSharpBehaviour
{
    [SerializeField] private MeshRenderer[] MushroomMesh;
    [SerializeField] private MeshRenderer[] LightFXMesh;
    [SerializeField] private float[] HueValue;

    void Start()
    {
        MaterialPropertyBlock MushroomBlock = new MaterialPropertyBlock();
        MaterialPropertyBlock LightFXBlock = new MaterialPropertyBlock();
        

        for (int i = 0; i < MushroomMesh.Length; i++)
        {
            
            MushroomBlock.SetFloat("_HueShift", HueValue[i]);
            MushroomBlock.SetFloat("_EmissionHueShift", HueValue[i]);
            LightFXBlock.SetFloat("_Hue", HueValue[i]);

            float randomLength = Random.Range(0f, 1f);
            LightFXBlock.SetFloat("_Length1", randomLength);

            MushroomMesh[i].SetPropertyBlock(MushroomBlock);
            LightFXMesh[i].SetPropertyBlock(LightFXBlock);
        }
    }
}
