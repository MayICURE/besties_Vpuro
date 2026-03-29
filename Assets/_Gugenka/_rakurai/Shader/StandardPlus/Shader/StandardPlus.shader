Shader "RAKURAIWORKS/StandardPlus"
{
    Properties
    {
        //AddProperties
        //Cull
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull", Float) = 2
        //ToneMap
        _UseToneMapping("ToneMapping",float) = 3
        [Toggle]_UseColorModifier("Color Modifier",float) = 0
        _ToneContrast("Contrast",Range(0.01,3.0)) = 1.0
        _Saturation("Contrast",Range(0.0,3.0)) = 1.0
        _HueShift("HueShift",Range(-1.0,1.0)) = 0.0
        _Exposure("Exposure",Range(-5.0,5.0)) = 0.0
        //GTToneMapping
        _GTMaxBrightness("GT MaxBrightness",float) = 1.0
        _GTContrast("GT Contrast",float) = 1.3
        _GTLinearStart("GT Linear Start",float) = 0.25
        _GTLinearLength("GT Linear Length",float) = 0.4
        _GTBlack("GT Black",float) = 1.0
        //GIBoost
        _MetaPassEmissiveBoost("Meta Pass Emissive Boost", Float) = 1.0

		//Occlusion By lightmapping
		[Toggle]_UseBakeOC("UseBakeAO",float) = 0.0
        _BakeOCIntensity("OcclusionIntensity",Range(0,1)) = 1.0
        _BakeOCPow("OcclusionContrast",Range(0.01,10.0)) = 1.0

        //Stencil
        [IntRange]_Ref("Stencil Ref",Range(0,255)) = 0

        //Planer Mapping Albedo
        [Toggle]_UsePlanarMappingAlbedo("Use PlanarMapping Albedo",float) = 0
        _AlbedoPlanerTex("PlanarTexture",2D) = "white"{}
        _AlbedoPlanarColor("Color",color) = (1,1,1,1)
        _AlbedoPlanarUV("Tiling And Scroll",Vector) = (1,1,0,0)
        //Planer Mapping Gloss
        [Toggle]_UsePlanarMappingGloss("Use PlanarMapping Gloss",float) = 0
        _GlossPlanerTex("PlanarTexture",2D) = "white"{}
        _GlossPlanarUV("Tiling And Scroll",Vector) = (1,1,0,0)
        _GlossRemapMin("GlossTex RemapMin",Range(-1,1)) = 0
        _GlossRemapMax("GlossTex RemapMax",Range(-1,1)) = 1
        //Planer Mapping Normal
        [Toggle]_UsePlanarMappingNormal("Use PlanarMapping Normal",float) = 0
        _NormalPlanerTex("PlanarTexture",2D) = "white"{}
        _NormalPlanarUV("Tiling And Scroll",Vector) = (1,1,0,0)
        _NormalPlanarScale("Scale",Range(-1,1)) = 0



        /* //old
        //EditCustomMap
        [Toggle]_UseCustomMap("CustomBakedMap",float) = 0.0
        _DarkMap("1stMap", 2D) = "white" {}
        [HDR]_DarkMapColor("DarkMapColor",color) = (1,1,1,1)
		_LitMap("2ndMap",2D)  = "white" {}
        [HDR]_LitMapColor("LitMapColor",color) = (1,1,1,1)
		_Change("Change",Range(0.0,1.0)) = 0.0
        //EditBakedMap
        [HDR]_BakedMapColor("BakedMapColor",color) = (1,1,1,1)
        _BakedMapContrast("BakedMapContrast",Range(0.01,15.0)) = 1.0
        //EditRealTimeMap
        [HDR]_RealTimeMapColor("RealTimeMapColor",color) = (1,1,1,1)
        _RealTimeMapContrast("RealTimeMapContrast",Range(0.01,15.0)) = 1.0
        //BakedAO
        [Toggle]_UseBakeOC("UseBakeAO",float) = 0.0
        _BakeOCIntensity("OcclusionIntensity",float) = 10.0
        _BakeOCPow("OcclusionContrast",Range(1.0,30.0)) = 15.0
        _BakeOCDirLerp("NormalInfluence",Range(0.0,1.0)) = 0.5
        //RealTimeAO
        [Toggle]_UseOC("UseRealTimeAO",float) = 0.0
        _OCIntensity("OcclusionIntensity",float) = 10.0
        _OCPow("OcclusionContrast",Range(1.0,30.0)) = 15.0
        _OCDirLerp("NormalInfluence",Range(0.0,1.0)) = 0.5
        */

        //Default
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" {}

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        _Glossiness("Smoothness", Range(0.0, 1.0)) = 0.5
        _GlossMapScale("Smoothness Scale", Range(0.0, 1.0)) = 1.0
        [Enum(Metallic Alpha,0,Albedo Alpha,1)] _SmoothnessTextureChannel ("Smoothness texture channel", Float) = 0

        [Gamma] _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" {}

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _GlossyReflections("Glossy Reflections", Float) = 1.0
		[Toggle] _ForceBoxProjection("Force BoxProjection", Float) = 0.0

        _BumpScale("Scale", Float) = 1.0
        [Normal] _BumpMap("Normal Map", 2D) = "bump" {}

        _Parallax ("Height Scale", Range (0.005, 0.08)) = 0.02
        _ParallaxMap ("Height Map", 2D) = "black" {}

        _OcclusionStrength("Strength", Range(0.01, 1.0)) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}

        _EmissionColor("Color", Color) = (0,0,0)
        _EmissionMap("Emission", 2D) = "white" {}

        _DetailMask("Detail Mask", 2D) = "white" {}

        _DetailAlbedoMap("Detail Albedo x2", 2D) = "grey" {}
        _DetailNormalMapScale("Scale", Float) = 1.0
        [Normal] _DetailNormalMap("Normal Map", 2D) = "bump" {}

        [Enum(UV0,0,UV1,1)] _UVSec ("UV Set for secondary textures", Float) = 0

        [HideInInspector] _Mode ("__mode", Float) = 0.0
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
        [HideInInspector] _DstBlend ("__dst", Float) = 0.0
        [HideInInspector] _ZWrite ("__zw", Float) = 1.0
    }

    CGINCLUDE
        #define UNITY_SETUP_BRDF_INPUT MetallicSetup
    ENDCG

    SubShader
    {
        Tags { "RenderType"="Opaque" "PerformanceChecks"="False" }
        LOD 300

        Stencil 
        {
            Ref [_Ref]
            Comp Equal
        }

        cull[_CullMode]


        // ------------------------------------------------------------------
        //  Base forward pass (directional light, emission, lightmaps, ...)
        Pass
        {
            Name "FORWARD"
            Tags { "LightMode" = "ForwardBase" }

            Blend [_SrcBlend] [_DstBlend]
            ZWrite [_ZWrite]
            //cull[_CullMode]

            CGPROGRAM
            #pragma target 3.0

            // -------------------------------------

            #pragma shader_feature _NORMALMAP
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature _ _GLOSSYREFLECTIONS_OFF
			#pragma shader_feature _ _FORCEBOXPROJECTION_ON
            #pragma shader_feature _PARALLAXMAP

            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            // Uncomment the following line to enable dithering LOD crossfade. Note: there are more in the file to uncomment for other passes.
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma vertex vertBase
            #pragma fragment fragBase
            #include "UnityStandardCoreForwardPlus.cginc"

            ENDCG
        }
        // ------------------------------------------------------------------
        //  Additive forward pass (one light per pass)
        Pass
        {
            Name "FORWARD_DELTA"
            Tags { "LightMode" = "ForwardAdd" }
            Blend [_SrcBlend] One
            //cull[_CullMode]
            Fog { Color (0,0,0,0) } // in additive pass fog should be black
            ZWrite Off
            ZTest LEqual

            CGPROGRAM
            #pragma target 3.0

            // -------------------------------------


            #pragma shader_feature _NORMALMAP
            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _ _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature _PARALLAXMAP

            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            // Uncomment the following line to enable dithering LOD crossfade. Note: there are more in the file to uncomment for other passes.
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma vertex vertAdd
            #pragma fragment fragAdd
            #include "UnityStandardCoreForwardPlus.cginc"

            ENDCG
        }
        // ------------------------------------------------------------------
        //  Shadow rendering pass
        Pass {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }

            ZWrite On ZTest LEqual

            CGPROGRAM
            #pragma target 3.0

            // -------------------------------------


            #pragma shader_feature _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature _PARALLAXMAP
            #pragma multi_compile_shadowcaster
            #pragma multi_compile_instancing
            // Uncomment the following line to enable dithering LOD crossfade. Note: there are more in the file to uncomment for other passes.
            //#pragma multi_compile _ LOD_FADE_CROSSFADE

            #pragma vertex vertShadowCaster
            #pragma fragment fragShadowCaster

            #include "UnityStandardShadow.cginc"

            ENDCG
        }
        
        // ------------------------------------------------------------------
        // Extracts information for lightmapping, GI (emission, albedo, ...)
        // This pass it not used during regular rendering.
        Pass
        {
            Name "META"
            Tags { "LightMode"="Meta" }

            Cull Off

            CGPROGRAM
            #pragma vertex vert_meta
            #pragma fragment frag_meta

            #pragma shader_feature _EMISSION
            #pragma shader_feature _METALLICGLOSSMAP
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature ___ _DETAIL_MULX2
            #pragma shader_feature EDITOR_VISUALIZATION

            #include "UnityStandardMetaPlus.cginc"
            ENDCG
        }
    }

    FallBack "VertexLit"
    CustomEditor "StandardPlusGUI"
}