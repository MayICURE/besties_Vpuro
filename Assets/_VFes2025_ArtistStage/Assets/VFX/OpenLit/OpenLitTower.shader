Shader "VFes2025ArtistStage/Tower"
{
    Properties
    {
        [Header(Common)]
        [Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
        //[Toggle]_EmissionIgnoreFog("Emission IgnoreFog", float) = 0
        //[Toggle]_OutlineIgnoreFog("Outline IgnoreFog", float) = 1

        [Header(LightingFunction)]
        _ShadowStrength("ShadowStrength", Range(0,1)) = 1
        _ShadowColor("ShadowColor", Color) = (0.85,0.85,0.85,1.0)
        _ShadowBorder("Shadow Border", Range(0,1)) = 0.5
        _ShadowBlur("Shadow Blur", Range(0,1)) = 0.2
        _LightMinLimit("Light Min Limit", Range(0,1)) = 0.0
        _LightMaxLimit("Light Max Limit", Range(0,100)) = 10

        [Header(MainTex)]
        _Color("Color", Color) = (1,1,1,0)
        _AlbedoIntensity("Albedo Intensity", float) = 1
		[SingleLineTexture][NoScaleOffset]_MainTex("MainTex", 2D) = "white" {}
        _MainTexUV("MainTex UV", Vector) = (1,1,0,0)
        [Toggle]_UseVertexColor("Use VertexColor", float) = 0

        [Header(Color Correction)]
        [Toggle(_HSVMOD_ON)]_UseHSVMod("Use ColorCorrection", float) = 0
        _Hue("Shift Hue", Range(-0.5,0.5)) = 0
        _Saturation("Shift Saturation", Range(0,2)) = 1
        _Value("Shift Value", Range(0,2)) = 1
        _Gamma("Shift Gamma", Range(0,2)) = 1

        [Header(Emissive)]
        [HDR]_EmissionColor("Color", Color) = (1,1,1,0)
        _EmissionIntensity("Intensity", Range(0,1)) = 0
        [SingleLineTexture][NoScaleOffset]_EmissionMap("EmissionMap", 2D) = "white" {}
        _EmissionMapUV("EmissionMap UV", Vector) = (1,1,0,0)

        [Header(NormalMap)]
        //_NormalScaleBase("NormalScaleBase", Float) = 1
		[SingleLineTexture][NoScaleOffset][Normal]_NormalMap1st("NormalMap 1st", 2D) = "bump" {}
		_NormalMap1stScale("NormalMap 1st Scale", Float) = 0
		_NormalMap1stUV("NormalMap 1st UV", Vector) = (1,1,0,0)
		_NormalMap1stScroll("NormalMap 1st Scroll", Vector) = (0,0,0,0)

        [Header(NormalMapMask)]
        _NormalMapMaskIntensity("NormalMap Mask Intensity", Range( 0 , 1)) = 0
        [SingleLineTexture][NoScaleOffset]_NormalMapMask("NormalMap Mask", 2D) = "white" {}

        [Header(Reflection)]
        [Toggle(_REFLECTION_ON)]_UseReflection("Use Reflection", float) = 0
        _Metallic("Metallic", Range(0,1)) = 0
        _Smoothness("Smoothness", Range(0,1)) = 0
        _ReflectionProbeIntensity("Intensity", float) = 1
        _RefLightDirMask("Reflection LightDirMask", Range(0,1)) = 0
        [Space(10)]
        [Toggle(_HIGHLIGHT_ON)]_UseHighLight("Use Highlight", float) = 0
        _HighLightIntensity("Intensity", float) = 1
        [Toggle]_UseHighLightSmoothness("Override Smoothness", float) = 0
        _HighLightSmoothness("HighlightSmoothness", Range(0,1)) = 0.5

        [Header(CubeMap)]
        [Toggle(_CUBEMAP_ON)]_UseCubeMap("Use CubeMap", float) = 0
        _CubeMap("CubeMap", CUBE) = "white" {}
        _CubeMapColor("Color", Color) = (1,1,1,0)
        _CubeMapIntensity("Intensity", float) = 0
        _CubeMapSmoothness("Smoothness", Range(0,1)) = 0
        _CubeLightDirMask("CubeMap LightDirMask", Range(0,1)) = 0
        [Toggle]_FetchProbePos("FetchProbePos", float) = 0

        [Header(RimLight)]
        [Toggle(_RIMLIGHT_ON)]_UseRimLight("Use RimLight", float) = 0
        _RimIntensity("RimLight Intensity", Range(0,1)) = 0
        [HDR]_RimColor("RimLight Color", Color) = (1,1,1,0)
        _RimBorder("RimLight Border", Range(0,1)) = 0.5
        _RimBlur("RimLight Blur", Range(0,1)) = 0.5
        _RimPower("RimLight Power", Range(0.001,50)) = 5
        _RimNormal("RimLight NormalStrength", Range(0,1)) = 0.5
        _RimLightDirMask("RimLight LightDirMask", Range(0,1)) = 0
        [Header(RimLightMask)]
        _RimLightMaskIntensity("RimLight Mask Intensity", Range( 0 , 1)) = 0
        [SingleLineTexture][NoScaleOffset]_RimLightMask("RimLight Mask", 2D) = "white" {}

        [Header(MatCap)]
        [Toggle(_MATCAP_ON)]_UseMatCap("Use MatCap", float) = 0
        _MatCap1stIntensity("MatCap 1st Intensity", Range( 0 , 1)) = 0
		[SingleLineTexture][NoScaleOffset]_MatCap1st("MatCap 1st", 2D) = "black" {}
		_MatCap1stColor("MatCap 1st Color", Color) = (1,1,1,0)
        _MatcapNormal("Matcap NormalStrength", Range(0,1)) = 1.0
        [Header(MatCapMask)]
        _MatCapMaskIntensity("MatCap Mask Intensity", Range( 0 , 1)) = 0
        [SingleLineTexture][NoScaleOffset]_MatCapMask("MatCap Mask", 2D) = "white" {}

        [Header(TowerFunc)]
        [HDR]_GlitchColor("GlitchColor", Color) = (0,0,0,0)
		_TilingBaseScale("Tiling BaseScale", Float) = 1
		_Tiling("Tiling", Vector) = (40,40,0,0)
		_ScrollBaseScale("Scroll BaseScale", Float) = 0
		_Scroll("Scroll", Vector) = (0,0,0,0)
		_MaskMin("MaskMin", Float) = 0.4
		_MaskMax("MaskMax", Float) = 1
		_MaskSmoothMin("MaskSmooth Min", Range( 0 , 1)) = 0
		_MaskSmoothMax("MaskSmooth Max", Range( 0 , 1)) = 1
		[Header(Scanline)]_ScanlineIntensity("Scanline Intensity", Range( 0 , 1)) = 0
		_ScanlineScale("Scanline Scale", Float) = 50
		_ScanlineScroll("Scanline Scroll", Float) = 0
		[Header(Grain)]_GrainIntensity("Grain Intensity", Range( 0 , 1)) = 0
		_GrainStrength("Grain Strength", Float) = 100
		[Toggle]_InvertGrain("Invert Grain", Float) = 0

        /*
        [Header(Outline)]
        _OutlineSize ("Outline Size", float) = 0
        _OutlineIntensity("Outline Intensity", Range(0,1)) = 1
        [HDR]_OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineVertexNoiseBias("Outline VertexNoiseBias", Range(0,1)) = 1
        _OutlineZBias("Outline ZBias", float) = 0
        [HideInInspector]_OutlineFixWidth("Outline FixWidth", Range(0,1)) = 0.5
        [Header(OutlineOffset)]
        _OutlineOffset("Outline Offset", Range(0,1)) = 0
        [SingleLineTexture][NoScaleOffset]_OutlineOffsetMap("Outline OffsetMap", 2D) ="white" {}
        _OutlineOffsetMapUV("Outline OffsetMap UV", Vector) = (1,1,0,0)
		_OutlineOffsetMapScroll("Outline OffsetMap Scroll", Vector) = (0,0,0,0)

        [Header(OutlineMask)]
        _OutlineMaskIntensity("Outline Mask Intensity", Range( 0 , 1)) = 0
        [SingleLineTexture][NoScaleOffset]_OutlineMask("Outline Mask", 2D) = "white" {}
        */

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        HLSLINCLUDE
            #pragma skip_variants LIGHTMAP_ON DYNAMICLIGHTMAP_ON LIGHTMAP_SHADOW_MIXING SHADOWS_SHADOWMASK DIRLIGHTMAP_COMBINED
            #pragma shader_feature_local _HSVMOD_ON
            #pragma shader_feature_local _REFLECTION_ON
            #pragma shader_feature_local _HIGHLIGHT_ON
            #pragma shader_feature_local _CUBEMAP_ON
            #pragma shader_feature_local _RIMLIGHT_ON
            #pragma shader_feature_local _MATCAP_ON

            uniform float _EmissionIgnoreFog;
            uniform float _OutlineIgnoreFog;

            uniform sampler2D _MainTex;
		    uniform float4 _MainTex_ST;
            uniform float4 _MainTexUV;
		    uniform float4 _Color;
            uniform float _AlbedoIntensity;
            uniform float _UseVertexColor;

            uniform float _Hue;
            uniform float _Saturation;
            uniform float _Value;
            uniform float _Gamma;

            uniform float _Metallic;
            uniform float _Smoothness;
            uniform float _ReflectionProbeIntensity;
            uniform float _RefLightDirMask;
            uniform float _HighLightIntensity;
            uniform float _UseHighLightSmoothness;
            uniform float _HighLightSmoothness;

            uniform samplerCUBE _CubeMap;
            uniform float4 _CubeMapColor;
            uniform float _CubeMapIntensity;
            uniform float _CubeMapSmoothness;
            uniform float _CubeLightDirMask;
            uniform float _FetchProbePos;

            uniform sampler2D _EmissionMap;
            uniform float4 _EmissionMapUV;
            uniform float4 _EmissionColor;
            uniform float _EmissionIntensity;

            uniform float _NormalScaleBase;
            uniform sampler2D _NormalMapMask;
            uniform float _NormalMapMaskIntensity;
            uniform sampler2D _NormalMap1st;
			uniform float4 _NormalMap1stUV;
			uniform float2 _NormalMap1stScroll;
			uniform float _NormalMap1stScale;

            uniform float _RimIntensity;
            uniform float4 _RimColor;
            uniform float _RimBorder;
            uniform float _RimBlur;
            uniform float _RimPower;
            uniform float _RimNormal;
            uniform float _RimLightDirMask;
            uniform float _RimLightMaskIntensity;
            uniform sampler2D _RimLightMask;

            uniform float _MatCapMaskIntensity;
            uniform sampler2D _MatCapMask;
            uniform float _MatcapNormal;
            uniform float _MatCap1stIntensity;
            uniform sampler2D _MatCap1st;
            uniform float4 _MatCap1stColor;

            float _OutlineIntensity;
            float _OutlineSize;
            float4 _OutlineColor;
            float _OutlineVertexNoiseBias;
            float _OutlineFixWidth;
            float _OutlineZBias;
            float _OutlineOffset;
            sampler2D _OutlineOffsetMap;
            float4 _OutlineOffsetMapUV;
            float4 _OutlineOffsetMapScroll;
            sampler2D _OutlineMask;
            float _OutlineMaskIntensity;

            float _ShadowStrength;
            float4 _ShadowColor;
            float _ShadowBorder;
            float _ShadowBlur;
            float _LightMinLimit;
            float _LightMaxLimit;

            //TowerFunc
            uniform float4 _GlitchColor;
		    uniform float _GrainStrength;
		    uniform float _InvertGrain;
		    uniform float _GrainIntensity;
		    uniform float _ScanlineScale;
		    uniform float _ScanlineScroll;
		    uniform float _ScanlineIntensity;
		    uniform float _MaskSmoothMin;
		    uniform float _MaskSmoothMax;
		    uniform float2 _Tiling;
		    uniform float _TilingBaseScale;
		    uniform float2 _Scroll;
		    uniform float _ScrollBaseScale;
		    uniform float _MaskMin;
		    uniform float _MaskMax;

        ENDHLSL

        Pass
        {
            Tags {"LightMode" = "ForwardBase"}

            BlendOp Add, Add
            Blend One Zero
            ZWrite On
			Cull [_CullMode]

            HLSLPROGRAM
            #pragma target 3.0
            //#pragma target 4.0
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            // [OpenLit] Include this
            #include "OpenLitCore_Fix.hlsl"

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
                float2 uv1      : TEXCOORD1;
                float3 normalOS : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;
                float4 color : COLOR;
                float3 positionWS   : TEXCOORD0;
                float2 uv           : TEXCOORD1;
                float2 uv2           : TEXCOORD12;
                float3 normalWS     : TEXCOORD2;
                float3 tangentWS    : TEXCOORD10;
                float3 bitangentWS    : TEXCOORD11;
                // [OpenLit] Add light datas
                nointerpolation float3 lightDirection : TEXCOORD3;
                nointerpolation float3 directLight : TEXCOORD4;
                nointerpolation float3 indirectLight : TEXCOORD5;
                UNITY_FOG_COORDS(6)
                UNITY_LIGHTING_COORDS(7, 8)
                #if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
                    float3 vertexLight  : TEXCOORD9;
                #endif
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                UNITY_SETUP_INSTANCE_ID(v);
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                UNITY_TRANSFER_INSTANCE_ID(v,o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.positionWS    = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));
                o.pos           = UnityWorldToClipPos(o.positionWS);
                o.uv            = v.uv;
                o.uv2            = v.uv1;
                o.normalWS      = UnityObjectToWorldNormal(v.normalOS);
                o.color = v.color;

                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
				o.tangentWS = worldTangent;
				float tangentSign = v.tangent.w * (unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0);
				float3 worldBitangent = cross(o.normalWS, worldTangent ) * tangentSign;
				o.bitangentWS.xyz = worldBitangent;

                UNITY_TRANSFER_FOG(o,o.pos);
                UNITY_TRANSFER_LIGHTING(o,v.uv1);

                // [OpenLit] Calculate and copy vertex lighting
                #if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH && defined(VERTEXLIGHT_ON)
                    o.vertexLight = ComputeAdditionalLights(o.positionWS, o.pos) * 0.0;
                    o.vertexLight = min(o.vertexLight, _LightMaxLimit);
                #endif

                // [OpenLit] Calculate and copy light datas
                OpenLitLightDatas lightDatas;
                ComputeLights(lightDatas, float4(0.001,0.002,0.001,0));
                CorrectLights(lightDatas, _LightMinLimit, _LightMaxLimit, 0.0, 0.0);
                o.lightDirection    = lightDatas.lightDirection;
                o.directLight       = lightDatas.directLight;
                o.indirectLight     = lightDatas.indirectLight;

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                float2 uv = i.uv;
                float3 worldViewDir = UnityWorldSpaceViewDir(i.positionWS);
				worldViewDir = normalize(worldViewDir);

				float4 color = float4(0,0,0,1);
                float4 vertColor = i.color;
				color = lerp(tex2D(_MainTex,uv * _MainTexUV.xy + _MainTexUV.zw), vertColor, _UseVertexColor)  * _Color;

                color.rgb *= _AlbedoIntensity;

                #ifdef _HSVMOD_ON
                    color.rgb = lilToneCorrection(color.rgb, float4(_Hue, _Saturation, _Value, _Gamma));
                #endif

                float4 emission = tex2D(_EmissionMap, uv * _EmissionMapUV.xy + _EmissionMapUV.zw) * _EmissionColor * _EmissionIntensity;

                //Blend NormalMap
                float normalMapMask = lerp(1.0, tex2D(_NormalMapMask, uv), _NormalMapMaskIntensity);
                float2 normal1stUV = uv * _NormalMap1stUV.xy + (_Time.y * _NormalMap1stScroll.xy);
				float3 normal1st = UnpackScaleNormal(tex2D(_NormalMap1st, normal1stUV), 1.0 * _NormalMap1stScale * normalMapMask);

                float3 blendNormal = normal1st;

                float3 worldTangent = normalize(i.tangentWS).xyz;
				float3 worldNormal = normalize(i.normalWS).xyz;
				float3 worldBitangent = normalize(i.bitangentWS).xyz;
                float3x3 tangentTransform = float3x3( worldTangent, worldBitangent, worldNormal);

                float3 worldNormalFix = normalize(mul( blendNormal, tangentTransform ));

                //Reflection
                #ifdef _REFLECTION_ON
                    float4 refColor;
                    float refDirMask = saturate(dot(i.lightDirection, worldNormalFix) * 0.5 + 0.5);
                    #ifdef _GLOSSYREFLECTIONS_OFF
                        refColor.rgb = unity_IndirectSpecColor.rgb;
                    #else
                        float roughness = SmoothnessToPerceptualRoughness(_Smoothness);
                        float3 reflUVW = reflect(-worldViewDir, worldNormalFix);
                        reflUVW = boxProjection(reflUVW, i.positionWS, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);

                        float perceptualRoughness = roughness*(1.7 - 0.7*roughness);
                        float specularMip = perceptualRoughnessToMipmapLevel(perceptualRoughness);
                        refColor = UNITY_SAMPLE_TEXCUBE_LOD(unity_SpecCube0, reflUVW, specularMip);
                        refColor.rgb = DecodeHDR(refColor, unity_SpecCube0_HDR);
                    #endif

                    refColor.rgb *= _ReflectionProbeIntensity;
                    refColor.rgb *= lerp(1.0, refDirMask, _RefLightDirMask);

                    float oneMinusReflectivity;
                    float3 specColor;
                    specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, color.rgb, _Metallic);
                    oneMinusReflectivity = OneMinusReflectivityFromMetallic(_Metallic);
                    color.rgb = color.rgb * oneMinusReflectivity;

                    //BRDF2
                    float nv = saturate(dot(worldNormalFix, worldViewDir));

                    half perceptualRoughnessBRDF = SmoothnessToPerceptualRoughness (_Smoothness);
                    half roughnessBRDF = PerceptualRoughnessToRoughness(perceptualRoughnessBRDF);

                    //Highlight
                    #ifdef _HIGHLIGHT_ON
                        float3 halfDir = Unity_SafeNormalize (float3(i.lightDirection) + worldViewDir);
                        float nh = saturate(dot(worldNormalFix, halfDir));
                        float lh = saturate(dot(i.lightDirection, halfDir));

                        half perceptualRoughnessBRDF2 = SmoothnessToPerceptualRoughness (_HighLightSmoothness);
                        half roughnessBRDF2 = PerceptualRoughnessToRoughness(perceptualRoughnessBRDF2);

                        half a = lerp(roughnessBRDF, roughnessBRDF2, _UseHighLightSmoothness);
                        float a2 = a*a;
                        float d = nh * nh * (a2 - 1.f) + 1.00001f;
                        #ifdef UNITY_COLORSPACE_GAMMA
                            float specularTerm = a / (max(0.32f, lh) * (1.5f + a) * d);
                        #else
                            float specularTerm = a2 / (max(0.1f, lh*lh) * (a + 0.5f) * (d * d) * 4);
                        #endif

                        #if defined (SHADER_API_MOBILE)
                            specularTerm = specularTerm - 1e-4f;
                            specularTerm = clamp(specularTerm, 0.0, 100.0); // Prevent FP16 overflow on mobiles
                        #endif

                        color.rgb += specColor * specularTerm * _HighLightIntensity * lerp(1.0, refDirMask, _RefLightDirMask);

                        //BRDF3
                        /*
                        float3 reflDir = reflect(worldViewDir, worldNormalFix);
                        half2 rlPow4AndFresnelTerm = Pow4 (float2(dot(reflDir, i.lightDirection), 1-nv));  // use R.L instead of N.H to save couple of instructions
                        half rlPow4 = rlPow4AndFresnelTerm.x;
                        half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp
                        // Lookup texture to save instructions
                        half specular = tex2D(unity_NHxRoughness, half2(rlPow4, SmoothnessToPerceptualRoughness(_Smoothness))).r * LUT_RANGE;
                        color.rgb += specColor * specular;
                        */
                    #endif


                    #ifdef UNITY_COLORSPACE_GAMMA
                        half surfaceReduction = 0.28;
                    #else
                        half surfaceReduction = (0.6-0.08*perceptualRoughnessBRDF);
                    #endif
                    surfaceReduction = 1.0 - roughnessBRDF*perceptualRoughnessBRDF*surfaceReduction;

                    float grazingTerm = saturate(_Smoothness + (1-oneMinusReflectivity));

                    color.rgb += refColor.rgb * FresnelLerpFast(specColor, grazingTerm, nv) * surfaceReduction;
                #endif

                //CubeMap
                #ifdef _CUBEMAP_ON
                    float cubeDirMask = saturate(dot(i.lightDirection, worldNormalFix) * 0.5 + 0.5);
                    float3 cubeUVW = reflect(-worldViewDir, worldNormalFix);
                    if(_FetchProbePos)cubeUVW = boxProjection(cubeUVW, i.positionWS, unity_SpecCube0_ProbePosition, unity_SpecCube0_BoxMin, unity_SpecCube0_BoxMax);
                    float cubeRoughness = SmoothnessToPerceptualRoughness(_CubeMapSmoothness);
                    float cubePerceptualRoughness = cubeRoughness*(1.7 - 0.7*cubeRoughness);
                    float cubeMip = perceptualRoughnessToMipmapLevel(cubePerceptualRoughness);
                    float3 cubeMap = texCUBElod(_CubeMap, float4(cubeUVW, cubeMip));
                    cubeMap = cubeMap * _CubeMapColor * _CubeMapIntensity * lerp(1.0, cubeDirMask, _CubeLightDirMask);
                    color.rgb += cubeMap;
                #endif

                //RimLight
                float3 rimColor = float3(0,0,0);
                #ifdef _RIMLIGHT_ON
                    float rimMask = lerp(1.0, tex2D(_RimLightMask, uv).r, _RimLightMaskIntensity);
                    float3 rimNormal = lerp(worldNormal, worldNormalFix, _RimNormal);
                    float rim = 1.0 - saturate(dot(rimNormal, worldViewDir));
                    rim = pow(rim, _RimPower);
                    float rimBorderMin = saturate(_RimBorder - _RimBlur * 0.5);
                    float rimBorderMax = saturate(_RimBorder + _RimBlur * 0.5);
                    rim = (rim - rimBorderMin) / saturate(rimBorderMax - rimBorderMin + fwidth(rim) * 1.0);
                    rim = saturate(rim);
                    float rimDirMask = saturate(dot(i.lightDirection, rimNormal) * 0.5 + 0.5);
                    rim *= lerp(1.0, rimDirMask, _RimLightDirMask);
                    rim *= rimMask;
                    rimColor = rim * _RimColor * _RimIntensity;
                #endif

                //Matcap
                float3 matcap = float3(0,0,0);
                #ifdef _MATCAP_ON
                    float3 matcapNormal = lerp(worldNormal, worldNormalFix, _MatcapNormal);
                    float matcapMask = lerp(1.0, tex2D(_MatCapMask, uv).r, _MatCapMaskIntensity);
                    float2 matcapUV = matcapSample(worldViewDir, matcapNormal);

				    float4 matcap1st = ( ( tex2D( _MatCap1st, matcapUV.xy ) * _MatCap1stColor ) * _MatCap1stIntensity );
                    matcap = (matcap1st * matcapMask).xyz;
                #endif

                //Tower
                float mulTime36 = _Time.y * 5.0;
			    float4 temp_cast_1 = (mulTime36).xxxx;
			    float div40=256.0/float(80);
			    float4 posterize40 = ( floor( temp_cast_1 * div40 ) / div40 );
			    float2 UV90 = i.uv2;
			    float2 break37 = UV90;
			    float GrainUV44 = ( (posterize40).r * ( ( 4.0 + break37.x ) * ( break37.y + 4.0 ) ) );
			    float temp_output_69_0 = ( fmod( ( ( fmod( GrainUV44 , 13.0 ) + 1.0 ) * ( fmod( GrainUV44 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 );
			    float temp_output_72_0 = ( temp_output_69_0 * _GrainStrength );
			    float lerpResult79 = lerp( temp_output_72_0 , ( 1.0 - temp_output_72_0 ) , _InvertGrain);
			    float lerpResult83 = lerp( 1.0 , lerpResult79 , _GrainIntensity);
			    float Grain85 = lerpResult83;
			    float temp_output_71_0 = sin( ( ( ( UV90 + float2( 0,0 ) ).x * _ScanlineScale ) + fmod( ( _Time.y * _ScanlineScroll ) , 6800.0 ) ) );
			    float lerpResult82 = lerp( 1.0 , pow( saturate( temp_output_71_0 ) , 3.0 ) , _ScanlineIntensity);
			    float Scanline84 = lerpResult82;
			    float2 temp_output_24_0 = ( ( UV90 * _Tiling * _TilingBaseScale ) + ( _Time.y * _Scroll * _ScrollBaseScale ) );
			    float dotResult4_g13 = dot( ( floor( temp_output_24_0 ) + float2( 0,0 ) ) , float2( 12.9898,78.233 ) );
			    float lerpResult10_g13 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g13 ) * 43758.55 ) ));
			    float temp_output_18_0 = lerpResult10_g13;
			    float YGrad7 = saturate( i.uv2.x );
			    float smoothstepResult14 = smoothstep( _MaskMin , _MaskMax , YGrad7);
			    float smoothstepResult125 = smoothstep( 0.0 , temp_output_18_0 , smoothstepResult14);
			    float smoothstepResult127 = smoothstep( _MaskSmoothMin , _MaskSmoothMax , ( 1.0 - saturate( smoothstepResult125 ) ));
			    float2 BaseUV225 = temp_output_24_0;
			    float dotResult4_g24 = dot( ( floor( BaseUV225 ) + float2( 17,9 ) ) , float2( 12.9898,78.233 ) );
			    float lerpResult10_g24 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g24 ) * 43758.55 ) ));
			    float temp_output_2_0_g36 = 0.95;
			    float temp_output_3_0_g36 = 0.95;
			    float2 appendResult21_g36 = (float2(temp_output_2_0_g36 , temp_output_3_0_g36));
			    float Radius25_g36 = max( min( min( abs( ( 0.05 * 2 ) ) , abs( temp_output_2_0_g36 ) ) , abs( temp_output_3_0_g36 ) ) , 1E-05 );
			    float2 temp_cast_2 = (0.0).xx;
			    float temp_output_30_0_g36 = ( length( max( ( ( abs( (frac( temp_output_24_0 )*2.0 + -1.0) ) - appendResult21_g36 ) + Radius25_g36 ) , temp_cast_2 ) ) / Radius25_g36 );
			    float FrameMask207 = ( ( 1.0 - saturate( ( ( 1.0 - temp_output_30_0_g36 ) / fwidth( temp_output_30_0_g36 ) ) ) ) * 0.3 );
                float4 tower = ( ( _GlitchColor * Grain85 * Scanline84 * ( ( 1.0 - smoothstepResult127 ) * (0.75 + (abs( sin( ( (0.0 + (lerpResult10_g24 - 0.0) * (10.0 - 0.0) / (1.0 - 0.0)) + _Time.y ) ) ) - 0.0) * (1.0 - 0.75) / (1.0 - 0.0)) ) ) + FrameMask207 );

                //OpenLit LightingFunc
                UNITY_LIGHT_ATTENUATION(attenuation, i, i.positionWS);
                OpenLitLightDatas lightDatas;
                lightDatas.lightDirection   = i.lightDirection;
                lightDatas.directLight      = i.directLight;
                lightDatas.indirectLight    = i.indirectLight;

                //float3 N = worldNormal;
                float3 N = worldNormalFix;
                float3 L = lightDatas.lightDirection;
                float NdotL = dot(N,L);

                float nl = saturate(NdotL * 0.5 + 0.5);
                float borderMin = saturate(_ShadowBorder - _ShadowBlur * 0.5);
                float borderMax = saturate(_ShadowBorder + _ShadowBlur * 0.5);
                float factor = (nl - borderMin) / saturate(borderMax - borderMin + fwidth(nl) * 1.0);
                factor = saturate(factor);
                factor *= attenuation;

                half3 albedo = color.rgb;
                color.rgb *= lerp(_ShadowColor.rgb * lightDatas.directLight, lightDatas.directLight, lerp(1.0,factor,_ShadowStrength));
                #if !defined(LIGHTMAP_ON) && UNITY_SHOULD_SAMPLE_SH
                    color.rgb += albedo.rgb * i.vertexLight;
                    color.rgb = min(color.rgb, albedo.rgb * _LightMaxLimit);
                #endif

                color.rgb += emission.rgb + matcap + rimColor;

                color.rgb = lerp(tower.rgb, color.rgb, smoothstepResult127);

                UNITY_APPLY_FOG(i.fogCoord, color);

                return color;
            }
            ENDHLSL
        }
    
        
        Pass
        {
            Tags {"LightMode" = "ForwardAdd"}

			BlendOp Max
            Blend One One
            ZWrite Off
            ZTest LEqual
			Cull [_CullMode]

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd
            //#pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "UnityPBSLighting.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            #include "OpenLitCore_Fix.hlsl"

            struct appdata
            {
                float4 vertex   : POSITION;
                float2 uv       : TEXCOORD0;
                float2 uv1      : TEXCOORD1;
                float3 normalOS : NORMAL;
                float4 tangent : TANGENT;
                float4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;
                float4 color : COLOR;
                float3 positionWS   : TEXCOORD0;
                float2 uv           : TEXCOORD1;
                float3 normalWS     : TEXCOORD2;
                float3 tangentWS    : TEXCOORD6;
                float3 bitangentWS    : TEXCOORD7;
                UNITY_FOG_COORDS(3)
                UNITY_LIGHTING_COORDS(4, 5)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.positionWS    = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));
                o.pos           = UnityWorldToClipPos(o.positionWS);
                o.uv            = v.uv;
                o.normalWS      = UnityObjectToWorldNormal(v.normalOS);
                o.color = v.color;

                float3 worldTangent = UnityObjectToWorldDir(v.tangent);
				o.tangentWS = worldTangent;
				float tangentSign = v.tangent.w * (unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0);
				float3 worldBitangent = cross(o.normalWS, worldTangent ) * tangentSign;
				o.bitangentWS.xyz = worldBitangent;

                UNITY_TRANSFER_FOG(o,o.pos);
                UNITY_TRANSFER_LIGHTING(o,v.uv1);
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

				float2 uv = i.uv;

				float4 color = float4(0,0,0,1);
                float4 vertColor = i.color;
				color = lerp(tex2D(_MainTex,uv * _MainTexUV.xy + _MainTexUV.zw), vertColor, _UseVertexColor)  * _Color;

                color.rgb *= _AlbedoIntensity;

                #ifdef _HSVMOD_ON
                    color.rgb = lilToneCorrection(color.rgb, float4(_Hue, _Saturation, _Value, _Gamma));
                #endif

                //Blend NormalMap
                float normalMapMask = lerp(1.0, tex2D(_NormalMapMask, uv), _NormalMapMaskIntensity);
                float2 normal1stUV = uv * _NormalMap1stUV.xy + (_Time.y * _NormalMap1stScroll.xy);
				float3 normal1st = UnpackScaleNormal(tex2D(_NormalMap1st, normal1stUV), 1.0 * _NormalMap1stScale * normalMapMask);

                float3 blendNormal = normal1st;

                float3 worldTangent = normalize(i.tangentWS).xyz;
				float3 worldNormal = normalize(i.normalWS).xyz;
				float3 worldBitangent = normalize(i.bitangentWS).xyz;
                float3x3 tangentTransform = float3x3( worldTangent, worldBitangent, worldNormal);

                float3 worldNormalFix = normalize(mul( blendNormal, tangentTransform ));

                //Reflection
                #ifdef _REFLECTION_ON
                    //Highlight
                    #ifdef _HIGHLIGHT_ON
                        float3 worldViewDir = UnityWorldSpaceViewDir(i.positionWS);
                        worldViewDir = normalize(worldViewDir);
                        float3 lightDirection = normalize(UnityWorldSpaceLightDir(i.positionWS));
                        float refDirMask = saturate(dot(lightDirection, worldNormalFix) * 0.5 + 0.5);

                        float3 specColor;
                        specColor = lerp (unity_ColorSpaceDielectricSpec.rgb, color.rgb, _Metallic);

                        half perceptualRoughnessBRDF = SmoothnessToPerceptualRoughness (_Smoothness);
                        half roughnessBRDF = PerceptualRoughnessToRoughness(perceptualRoughnessBRDF);
                        half perceptualRoughnessBRDF2 = SmoothnessToPerceptualRoughness (_HighLightSmoothness);
                        half roughnessBRDF2 = PerceptualRoughnessToRoughness(perceptualRoughnessBRDF2);

                        float3 halfDir = Unity_SafeNormalize (float3(lightDirection) + worldViewDir);
                        float nh = saturate(dot(worldNormalFix, halfDir));
                        float lh = saturate(dot(lightDirection, halfDir));

                        half a = lerp(roughnessBRDF, roughnessBRDF2, _UseHighLightSmoothness);
                        float a2 = a*a;
                        float d = nh * nh * (a2 - 1.f) + 1.00001f;
                        #ifdef UNITY_COLORSPACE_GAMMA
                            float specularTerm = a / (max(0.32f, lh) * (1.5f + a) * d);
                        #else
                            float specularTerm = a2 / (max(0.1f, lh*lh) * (a + 0.5f) * (d * d) * 4);
                        #endif

                        #if defined (SHADER_API_MOBILE)
                            specularTerm = specularTerm - 1e-4f;
                            specularTerm = clamp(specularTerm, 0.0, 100.0); // Prevent FP16 overflow on mobiles
                        #endif

                        color.rgb += specColor * specularTerm * _HighLightIntensity * lerp(1.0, refDirMask, _RefLightDirMask);

                        /*
                        float nv = saturate(dot(worldNormalFix, worldViewDir));
                        float3 reflDir = reflect(worldViewDir, worldNormalFix);
                        half2 rlPow4AndFresnelTerm = Pow4 (float2(dot(reflDir, i.lightDirection), 1-nv));  // use R.L instead of N.H to save couple of instructions
                        half rlPow4 = rlPow4AndFresnelTerm.x;
                        half LUT_RANGE = 16.0; // must match range in NHxRoughness() function in GeneratedTextures.cpp
                        // Lookup texture to save instructions
                        half specular = tex2D(unity_NHxRoughness, half2(rlPow4, SmoothnessToPerceptualRoughness(_Smoothness))).r * LUT_RANGE;
                        color.rgb += specColor * specular;
                        */
                    #endif
                #endif
				
                //OpenLit LightingFunc
                UNITY_LIGHT_ATTENUATION(attenuation, i, i.positionWS);
                //float3 N = worldNormal;
                float3 N = worldNormalFix;
                float3 L = normalize(UnityWorldSpaceLightDir(i.positionWS));
                float NdotL = dot(N,L);

                float nl = saturate(NdotL * 0.5 + 0.5);
                float borderMin = saturate(_ShadowBorder - _ShadowBlur * 0.5);
                float borderMax = saturate(_ShadowBorder + _ShadowBlur * 0.5);
                float factor = (nl - borderMin) / saturate(borderMax - borderMin + fwidth(nl) * 1.0);
                factor = saturate(factor);

				float3 lc = min(OPENLIT_LIGHT_COLOR * attenuation,_LightMaxLimit);
				color.rgb *= lerp(lc * _ShadowColor,lc,factor);

                //color.rgb *= lerp(0.0, OPENLIT_LIGHT_COLOR, factor * attenuation);

                UNITY_APPLY_FOG(i.fogCoord, color);

                return color;
            }
            ENDHLSL
        }
        
        /*
        Pass
        {
            Cull Front

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex   : POSITION;
                float3 normalOS : NORMAL;
                float2 uv       : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos          : SV_POSITION;
                float3 normalWS     : TEXCOORD1;
                UNITY_FOG_COORDS(2)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float3 lilHeadDirection(float3 positionWS)
            {
                #if defined(USING_STEREO_MATRICES)
                    return (unity_StereoWorldSpaceCameraPos[0].xyz + unity_StereoWorldSpaceCameraPos[1].xyz) * 0.5 - positionWS;
                #else
                    return _WorldSpaceCameraPos.xyz - positionWS;
                #endif
            }

            float3 lilViewDirectionOS(float3 positionOS)
            {
                return mul(unity_WorldToObject, float4(_WorldSpaceCameraPos.xyz, 1.0)).xyz - positionOS;
            }

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_INITIALIZE_OUTPUT(v2f,o);
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                float randN = lerp(-1.0,1.0,rand(v.uv)) * 0.0;

                //float outlineMask = lerp(1.0, tex2Dlod(_OutlineMask, float4((v.uv * 0.8) + float2(0.0, _Time.y * -0.05), 0, 0.0)).r, _OutlineMaskIntensity);
                float outlineOffset = tex2Dlod(_OutlineOffsetMap, float4(v.uv * _OutlineOffsetMapUV.xy + (_OutlineOffsetMapScroll.xy * _Time.y) + randN, 0, 0.0)).r;
                outlineOffset = saturate(outlineOffset);
                outlineOffset = smoothstep(0.0,1.0,outlineOffset);
                outlineOffset = lerp(1.0,outlineOffset,_OutlineOffset);
                float outlineMask = lerp(1.0, tex2Dlod(_OutlineMask, float4(v.uv, 0, 0.0)).r, _OutlineMaskIntensity);


                float3 positionWS = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0));
                float width = _OutlineSize * 0.01;
                width *= lerp(1.0, saturate(length(lilHeadDirection(positionWS))), _OutlineFixWidth);
                float3 outlineN = v.normalOS;
                v.vertex.xyz += outlineN * width * outlineOffset * outlineMask;

                float3 V = unity_OrthoParams.w == 0 ? lilViewDirectionOS(v.vertex.xyz) : mul((float3x3)unity_WorldToObject, UNITY_MATRIX_V._m20_m21_m22);
                v.vertex.xyz -= normalize(V) * _OutlineZBias;

                o.pos = UnityObjectToClipPos(v.vertex);

                UNITY_TRANSFER_FOG(o,o.pos);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);

                float4 color = float4(0,0,0,1);
                color.rgb = _OutlineColor.rgb * _OutlineIntensity;

                if(!_OutlineIgnoreFog)
                {
                    UNITY_APPLY_FOG(i.fogCoord, color);
                }

                //UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDHLSL
        }
        */
		
    }
    Fallback "Standard"
}
