using UnityEngine;
using UnityEditor;

public class MetaFixGUI : ShaderGUI
{

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] properties)
    {

        base.OnGUI(materialEditor, properties);

        Material mtl = materialEditor.target as Material;

        int GIMode = mtl.GetInt("_GIMode");
        
        if(GIMode == 0)
        {
            mtl.globalIlluminationFlags = MaterialGlobalIlluminationFlags.BakedEmissive;
        }
        else if(GIMode == 1)
        {
            mtl.globalIlluminationFlags = MaterialGlobalIlluminationFlags.RealtimeEmissive;
        }

    }
}
