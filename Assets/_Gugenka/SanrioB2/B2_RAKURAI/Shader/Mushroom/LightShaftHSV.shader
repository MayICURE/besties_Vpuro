// Upgrade NOTE: upgraded instancing buffer 'SanrioB2LightShaftHSV' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/B2/LightShaftHSV"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		[Toggle]_InvertUV("InvertUV", Float) = 0
		_HueBaseOffset("HueBaseOffset",Range(-1.0,1.0)) = 0
		_Hue("Hue", Range( 0 , 1)) = 0
		_Saturation("Saturation", Range( 0 , 1)) = 0
		_Value("Value", Range( 0 , 1)) = 1
		_Alpha("Alpha", Range( 0 , 1)) = 0.5
		_Emissive("Emissive", Float) = 1
		_RimEdgeFade("Rim EdgeFade", Range( 0 , 1)) = 0
		_DepthFadeDistance("DepthFadeDistance", Float) = 0
		_LimmitMin("LimmitMin", Range( 0 , 1)) = 0
		_LimmitMax("LimmitMax", Range( 0 , 1)) = 1
		[NoScaleOffset]_MainNoise("MainNoise", 2D) = "white" {}
		_MainNoiseTilingAndScroll("MainNoise Tiling And Scroll", Vector) = (1,1,0,0)
		_MainStepMin("MainStepMin", Range( 0 , 1)) = 0
		_MainStepMax("MainStepMax", Range( 0 , 1)) = 1
		_SubNoiseIntensity("SubNoiseIntensity", Range( 0 , 1)) = 0
		[NoScaleOffset]_SubNoise("SubNoise", 2D) = "white" {}
		_SubNoiseTilingAndScroll("SubNoise Tiling And Scroll", Vector) = (1,1,0,0)
		_SubStepMin("SubStepMin", Range( 0 , 1)) = 0
		_SubStepMax("SubStepMax", Range( 0 , 1)) = 1
		[NoScaleOffset]_DustTex("DustTex", 2D) = "white" {}
		_DustTexTilingAndOffset("DustTex TilingAndOffset", Vector) = (1,1,0,0)
		_DustIntensity("DustIntensity", Range( 0 , 1)) = 0
		_DustStepMin("DustStepMin", Range( 0 , 1)) = 0
		_DustStepMax("DustStepMax", Range( 0 , 1)) = 1
		[Toggle]_UseAnimateIntensity("UseAnimateIntensity", Float) = 0
		[NoScaleOffset]_AnimateIntensity("AnimateIntensity", 2D) = "white" {}
		_IntensityMin("IntensityMin", Range( 0 , 1)) = 0.9
		_IntensityMax("IntensityMax", Range( 0 , 1)) = 1
		_AnimateSpeed("AnimateSpeed", Float) = 0
		_AnimateOffset("AnimateOffset", Range( 0 , 1)) = 0
		[Toggle]_UseFlicker("UseFlicker", Float) = 0
		_FlickerScale("FlickerScale", Range( 0 , 1)) = 1
		_FlickerPowerMin("Flicker PowerMin", Range( 0 , 1)) = 0.9
		_FlickerTimeScale("Flicker TimeScale", Float) = 15
		_FlickerSeed("FlickerSeed", Float) = 0
		_CameraFadeStartPos("CameraFadeStartPos", Float) = 2
		_CameraFadeEndPos("CameraFadeEndPos", Float) = 0.5
		_CameraFadeAlphaMin("CameraFadeAlphaMin", Range( 0 , 1)) = 0
		[Toggle]_UseScaleOffset("UseScaleOffset", Float) = 0
		[Toggle]_VetexOffsetInverseUV("InverseUV", Float) = 0
		_Width1("Width", Range( -1 , 1)) = 0
		_Length1("Length", Range( -5 , 5)) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "DisableBatching" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			half ASEVFace : VFACE;
			INTERNAL_DATA
			float4 screenPos;
		};

		uniform float _CullMode;
		uniform float _VetexOffsetInverseUV;
		uniform float _Width1;
		//uniform float _Length1;
		uniform float _UseScaleOffset;
		uniform float _Emissive;
		uniform float _LimmitMin;
		uniform float _LimmitMax;
		uniform float _InvertUV;
		uniform float _MainStepMin;
		uniform float _MainStepMax;
		uniform sampler2D _MainNoise;
		uniform float4 _MainNoiseTilingAndScroll;
		uniform float _SubStepMin;
		uniform float _SubStepMax;
		uniform sampler2D _SubNoise;
		uniform float4 _SubNoiseTilingAndScroll;
		uniform float _SubNoiseIntensity;
		uniform float _DustStepMin;
		uniform float _DustStepMax;
		uniform sampler2D _DustTex;
		uniform float4 _DustTexTilingAndOffset;
		uniform float _DustIntensity;
		uniform float _RimEdgeFade;
		uniform float _FlickerTimeScale;
		uniform float _FlickerSeed;
		uniform float _FlickerPowerMin;
		uniform float _FlickerScale;
		uniform float _UseFlicker;
		uniform sampler2D _AnimateIntensity;
		uniform float _AnimateSpeed;
		uniform float _AnimateOffset;
		uniform float _IntensityMin;
		uniform float _IntensityMax;
		uniform float _UseAnimateIntensity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _DepthFadeDistance;
		uniform float _CameraFadeEndPos;
		uniform float _CameraFadeStartPos;
		uniform float _CameraFadeAlphaMin;

		uniform float _HueBaseOffset;

		UNITY_INSTANCING_BUFFER_START(SanrioB2LightShaftHSV)
			UNITY_DEFINE_INSTANCED_PROP(float, _Hue)
#define _Hue_arr SanrioB2LightShaftHSV
			UNITY_DEFINE_INSTANCED_PROP(float, _Saturation)
#define _Saturation_arr SanrioB2LightShaftHSV
			UNITY_DEFINE_INSTANCED_PROP(float, _Value)
#define _Value_arr SanrioB2LightShaftHSV
			UNITY_DEFINE_INSTANCED_PROP(float, _Alpha)
#define _Alpha_arr SanrioB2LightShaftHSV
            UNITY_DEFINE_INSTANCED_PROP(float, _Length1)
#define _Length1_arr SanrioB2LightShaftHSV
		UNITY_INSTANCING_BUFFER_END(SanrioB2LightShaftHSV)


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );

			float _Length1_Instance = UNITY_ACCESS_INSTANCED_PROP(_Length1_arr,_Length1);

			float lerpResult209 = lerp( v.texcoord.xy.y , ( 1.0 - v.texcoord.xy.y ) , _VetexOffsetInverseUV);
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult194 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.z));
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult195 = (float2(ase_vertexNormal.x , ase_vertexNormal.z));
			float2 break201 = ( ( lerpResult209 * ( (-0.03 + (_Width1 - -1.0) * (0.03 - -0.03) / (1.0 - -1.0)) * 100.0 ) ) * ( appendResult194 + appendResult195 ) );
			float3 appendResult203 = (float3(break201.x , ( ase_vertex3Pos.y * _Length1_Instance ) , break201.y));
			float3 lerpResult206 = lerp( float3( 0,0,0 ) , appendResult203 , _UseScaleOffset);
			float3 VertexOffset204 = lerpResult206;
			v.vertex.xyz += VertexOffset204;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float _Hue_Instance = UNITY_ACCESS_INSTANCED_PROP(_Hue_arr, _Hue);
			float _Saturation_Instance = UNITY_ACCESS_INSTANCED_PROP(_Saturation_arr, _Saturation);
			float _Value_Instance = UNITY_ACCESS_INSTANCED_PROP(_Value_arr, _Value);
			float3 hsvTorgb229 = HSVToRGB( float3(_Hue_Instance + _HueBaseOffset,_Saturation_Instance,_Value_Instance) );
			o.Emission = ( hsvTorgb229 * _Emissive );
			float _Alpha_Instance = UNITY_ACCESS_INSTANCED_PROP(_Alpha_arr, _Alpha);
			float lerpResult57 = lerp( ( 1.0 - i.uv_texcoord.y ) , i.uv_texcoord.y , _InvertUV);
			float smoothstepResult60 = smoothstep( _LimmitMin , _LimmitMax , lerpResult57);
			float MainAlpha66 = saturate( smoothstepResult60 );
			float2 appendResult11 = (float2(_MainNoiseTilingAndScroll.x , _MainNoiseTilingAndScroll.y));
			float2 temp_output_14_0 = ( i.uv_texcoord * appendResult11 );
			float2 appendResult12 = (float2(_MainNoiseTilingAndScroll.z , _MainNoiseTilingAndScroll.w));
			float mulTime20 = _Time.y * -0.9;
			float smoothstepResult26 = smoothstep( _MainStepMin , _MainStepMax , ( tex2D( _MainNoise, ( temp_output_14_0 + ( appendResult12 * _Time.y ) ) ).r * tex2D( _MainNoise, ( ( temp_output_14_0 * float2( 0.85,0.85 ) ) + ( appendResult12 * mulTime20 ) ) ).r ));
			float MainNoise29 = smoothstepResult26;
			float2 appendResult32 = (float2(_SubNoiseTilingAndScroll.x , _SubNoiseTilingAndScroll.y));
			float2 temp_output_33_0 = ( i.uv_texcoord * appendResult32 );
			float2 appendResult34 = (float2(_SubNoiseTilingAndScroll.z , _SubNoiseTilingAndScroll.w));
			float mulTime39 = _Time.y * -0.9;
			float smoothstepResult48 = smoothstep( _SubStepMin , _SubStepMax , ( tex2D( _SubNoise, ( temp_output_33_0 + ( appendResult34 * _Time.y ) ) ).r * tex2D( _SubNoise, ( ( temp_output_33_0 * float2( 0.85,0.85 ) ) + ( appendResult34 * mulTime39 ) ) ).r ));
			float SubNoise49 = smoothstepResult48;
			float SubNoiseMask72 = ( 1.0 - smoothstepResult60 );
			float2 appendResult154 = (float2(_DustTexTilingAndOffset.x , _DustTexTilingAndOffset.y));
			float2 appendResult155 = (float2(_DustTexTilingAndOffset.z , _DustTexTilingAndOffset.w));
			float smoothstepResult169 = smoothstep( _DustStepMin , _DustStepMax , tex2D( _DustTex, ( ( appendResult154 * i.uv_texcoord ) + ( appendResult155 * _Time.y ) ) ).r);
			float Dust174 = saturate( smoothstepResult169 );
			float AppendNoise83 = saturate( ( ( MainNoise29 - ( ( SubNoise49 * SubNoiseMask72 ) * _SubNoiseIntensity ) ) - ( Dust174 * _DustIntensity ) ) );
			float3 ase_worldNormal = i.worldNormal;
			float3 switchResult91 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float fresnelNdotV92 = dot( switchResult91, i.viewDir );
			float fresnelNode92 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV92, 5.0 ) );
			float smoothstepResult96 = smoothstep( _RimEdgeFade , 1.0 , ( 1.0 - saturate( fresnelNode92 ) ));
			float SoftEdge98 = saturate( smoothstepResult96 );
			float mulTime101 = _Time.y * _FlickerTimeScale;
			float2 appendResult103 = (float2(mulTime101 , _FlickerSeed));
			float dotResult4_g7 = dot( trunc( appendResult103 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g7 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g7 ) * 43758.55 ) ));
			float Flicker111 = ( (_FlickerPowerMin + ((0.0 + (lerpResult10_g7 - 0.25) * (1.0 - 0.0) / (0.75 - 0.25)) - 0.0) * (1.0 - _FlickerPowerMin) / (1.0 - 0.0)) * _FlickerScale );
			float lerpResult121 = lerp( 1.0 , Flicker111 , _UseFlicker);
			float mulTime131 = _Time.y * _AnimateSpeed;
			float2 appendResult132 = (float2(mulTime131 , _AnimateOffset));
			float AnimateIntensity137 = (_IntensityMin + (tex2D( _AnimateIntensity, appendResult132 ).r - 0.0) * (_IntensityMax - _IntensityMin) / (1.0 - 0.0));
			float lerpResult140 = lerp( 1.0 , AnimateIntensity137 , _UseAnimateIntensity);
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth112 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth112 = abs( ( screenDepth112 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthFadeDistance ) );
			float DepthFade116 = saturate( distanceDepth112 );
			float3 ase_worldPos = i.worldPos;
			float CameraDistanceFade220 = saturate( (_CameraFadeAlphaMin + (distance( ase_worldPos , _WorldSpaceCameraPos ) - _CameraFadeEndPos) * (1.0 - _CameraFadeAlphaMin) / (_CameraFadeStartPos - _CameraFadeEndPos)) );
			o.Alpha = ( _Alpha_Instance * saturate( ( ( ( ( ( ( MainAlpha66 * AppendNoise83 ) * SoftEdge98 ) * lerpResult121 ) * lerpResult140 ) * DepthFade116 ) * CameraDistanceFade220 ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
0;52;1906;967;3106.898;4328.486;3.879441;True;True
Node;AmplifyShaderEditor.CommentaryNode;184;-6987.315,-5857.308;Inherit;False;3018.245;2652.165;Comment;55;30;31;32;34;39;36;7;33;9;38;11;41;37;40;42;17;12;20;14;35;44;43;22;19;16;45;15;46;18;47;21;24;48;23;25;27;28;49;26;29;153;154;149;155;158;156;160;152;157;171;170;163;169;173;174;MainNoise;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;30;-6928.397,-4495.395;Inherit;False;Property;_SubNoiseTilingAndScroll;SubNoise Tiling And Scroll;18;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;31;-6890.428,-4637.719;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;32;-6606.032,-4509.719;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;74;-6996.854,-1987.852;Inherit;False;2296.324;521.6235;Comment;11;56;59;58;63;62;57;60;64;66;73;72;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-6616.329,-4402.218;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-6674.625,-4167.987;Inherit;False;1;0;FLOAT;-0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;36;-6669.914,-4269.381;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;7;-6929.56,-5420.831;Inherit;False;Property;_MainNoiseTilingAndScroll;MainNoise Tiling And Scroll;13;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-6461.575,-4577.721;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-6429.369,-4200.579;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;-6946.854,-1933.852;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;11;-6607.195,-5435.155;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;153;-6752.091,-3611.859;Inherit;False;Property;_DustTexTilingAndOffset;DustTex TilingAndOffset;22;0;Create;True;0;0;0;False;0;False;1,1,0,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-6173.952,-4331.637;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;9;-6891.59,-5563.155;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-6439.236,-4364.721;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-5963.952,-4291.637;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;42;-5971.574,-4582.721;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;58;-6531.854,-1932.852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;20;-6675.789,-5093.424;Inherit;False;1;0;FLOAT;-0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-6462.738,-5503.157;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;158;-6403.129,-3345.854;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;149;-6937.315,-3364.143;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;59;-6505.854,-1778.852;Inherit;False;Property;_InvertUV;InvertUV;1;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;35;-6297.78,-4881.871;Inherit;True;Property;_SubNoise;SubNoise;17;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleTimeNode;17;-6671.077,-5194.818;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;12;-6617.492,-5327.654;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;154;-6391.176,-3578.261;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;155;-6394.091,-3470.16;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-6440.399,-5290.157;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-6175.115,-5257.073;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;43;-5647.312,-4689.768;Inherit;True;Property;_TextureSample2;Texture Sample 2;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;63;-5833.854,-1773.852;Inherit;False;Property;_LimmitMax;LimmitMax;11;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;-6035.164,-3580.058;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-6430.532,-5126.017;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;44;-5649.91,-4398.567;Inherit;True;Property;_TextureSample3;Texture Sample 3;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;62;-5837.854,-1866.852;Inherit;False;Property;_LimmitMin;LimmitMin;10;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;57;-6109.854,-1937.852;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;160;-6033.929,-3466.76;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-5965.115,-5217.073;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-5258.611,-4462.268;Inherit;False;Property;_SubStepMax;SubStepMax;20;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;157;-5777.33,-3581.554;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-5259.912,-4551.968;Inherit;False;Property;_SubStepMin;SubStepMin;19;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;60;-5511.854,-1935.852;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;18;-6297.943,-5807.308;Inherit;True;Property;_MainNoise;MainNoise;12;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleAddOpNode;15;-5972.737,-5508.157;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;152;-5874.412,-3924.755;Inherit;True;Property;_DustTex;DustTex;21;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-5265.11,-4659.869;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;48;-4854.316,-4657.268;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;73;-5228.726,-1720.228;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;163;-5462.468,-3894.304;Inherit;True;Property;_TextureSample4;Texture Sample 4;30;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;171;-5061.07,-3653.173;Inherit;False;Property;_DustStepMax;DustStepMax;25;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;170;-5062.07,-3745.173;Inherit;False;Property;_DustStepMin;DustStepMin;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;99;-7008.494,-1307.766;Inherit;False;2400.206;398.0544;Comment;12;111;110;109;108;107;106;105;104;103;102;101;100;RandomFlicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;24;-5651.073,-5324.004;Inherit;True;Property;_TextureSample1;Texture Sample 1;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;87;-7007.516,-164.5211;Inherit;False;2370.755;451.4976;Comment;11;98;97;96;95;94;93;92;91;90;89;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;23;-5648.475,-5615.203;Inherit;True;Property;_TextureSample0;Texture Sample 0;3;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;27;-5261.075,-5477.404;Inherit;False;Property;_MainStepMin;MainStepMin;14;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;72;-4924.531,-1622.729;Inherit;False;SubNoiseMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-6958.494,-1257.766;Inherit;False;Property;_FlickerTimeScale;Flicker TimeScale;35;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-4543.581,-4658.924;Inherit;False;SubNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-5259.774,-5387.704;Inherit;False;Property;_MainStepMax;MainStepMax;15;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;88;-6957.516,-78.39217;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;183;-6980.743,-2928.021;Inherit;False;1975.18;539;Comment;13;78;77;80;79;75;81;76;83;82;179;180;181;182;NoiseAppend;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-5266.273,-5585.305;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;169;-4709.071,-3864.173;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;26;-4855.478,-5582.704;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;-6930.743,-2591.021;Inherit;False;72;SubNoiseMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;173;-4407.07,-3865.173;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;89;-6711.565,-23.90414;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;76;-6915.743,-2733.021;Inherit;False;49;SubNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;101;-6741.494,-1252.766;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-6767.248,-1145.358;Inherit;False;Property;_FlickerSeed;FlickerSeed;36;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;103;-6343.792,-1247.601;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SwitchByFaceNode;91;-6522.984,-114.5211;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-6786.743,-2505.021;Inherit;False;Property;_SubNoiseIntensity;SubNoiseIntensity;16;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;90;-6619.581,98.97588;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;77;-6703.743,-2678.021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-4544.744,-5584.359;Inherit;False;MainNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;174;-4193.071,-3870.173;Inherit;False;Dust;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TruncOpNode;104;-6180.493,-1246.766;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-6265.215,-2672.882;Inherit;False;174;Dust;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;138;-6986.075,-737.0582;Inherit;False;2141.477;354.6396;Comment;9;129;130;131;132;136;133;135;137;134;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;92;-6322.409,-61.07112;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;-6908.743,-2878.021;Inherit;False;29;MainNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;182;-6331.215,-2537.882;Inherit;False;Property;_DustIntensity;DustIntensity;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;79;-6488.743,-2677.021;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;105;-6037.975,-1246.766;Inherit;False;Random Range;-1;;7;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;81;-6268.743,-2864.021;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;93;-6074.388,-61.02412;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-6936.075,-664.4293;Inherit;False;Property;_AnimateSpeed;AnimateSpeed;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;212;-3857.532,-5857.715;Inherit;False;3189.934;741.02;Comment;24;205;190;186;196;188;189;192;191;210;211;194;193;209;195;197;198;199;200;201;202;203;207;206;204;VertexOffset;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;180;-5983.215,-2639.882;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;205;-3807.532,-5805.951;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;94;-6067.164,53.40983;Inherit;False;Property;_RimEdgeFade;Rim EdgeFade;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;106;-5815.78,-1247.686;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.75;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;179;-5852.215,-2856.882;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-5936.564,-1025.712;Inherit;False;Property;_FlickerPowerMin;Flicker PowerMin;34;0;Create;True;0;0;0;False;0;False;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;95;-5925.165,-59.59114;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-6751.835,-543.0582;Inherit;False;Property;_AnimateOffset;AnimateOffset;31;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;131;-6659.835,-660.0582;Inherit;False;1;0;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;96;-5703.165,-58.59114;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;82;-5489.133,-2860.881;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;64;-5181.854,-1933.852;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-5425.948,-1068.441;Inherit;False;Property;_FlickerScale;FlickerScale;33;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;190;-3559.656,-5807.715;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.DynamicAppendNode;132;-6398.835,-661.0582;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;109;-5571.658,-1249.144;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.9;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;196;-3380.996,-5782.496;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;133;-5707.322,-498.4182;Inherit;False;Property;_IntensityMax;IntensityMax;29;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;117;-4585.663,-1985.703;Inherit;False;1039.177;185;Comment;4;112;113;114;116;DepthFade;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;83;-5229.563,-2864.222;Inherit;False;AppendNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;135;-5708.664,-584.9852;Inherit;False;Property;_IntensityMin;IntensityMin;28;0;Create;True;0;0;0;False;0;False;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-5079.95,-1248.441;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-3424.726,-5506.517;Inherit;False;Property;_Width1;Width;42;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;97;-5428.763,-56.96516;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;66;-4927.854,-1937.852;Inherit;False;MainAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;134;-6117.835,-687.0582;Inherit;True;Property;_AnimateIntensity;AnimateIntensity;27;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;68f7e4e994467a24ba3bc659a84c5d59;68f7e4e994467a24ba3bc659a84c5d59;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;113;-4535.662,-1918.241;Inherit;False;Property;_DepthFadeDistance;DepthFadeDistance;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;98;-4860.764,-58.96516;Inherit;False;SoftEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;211;-3030.043,-5620.903;Inherit;False;Property;_VetexOffsetInverseUV;InverseUV;41;1;[Toggle];Create;False;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;111;-4832.288,-1234.865;Inherit;False;Flicker;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;213;-3853.85,-4865.569;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;214;-3852.833,-5015.35;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;68;-2166.224,-2468.193;Inherit;False;66;MainAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2180.661,-2362.285;Inherit;False;83;AppendNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;188;-2610.297,-5650.097;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;189;-2492.297,-5386.097;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;192;-3050.995,-5516.372;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.03;False;4;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;210;-3162.043,-5703.903;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;136;-5395.204,-656.6031;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;191;-3078.817,-5232.695;Inherit;False;Constant;_Float10;Float 9;15;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;112;-4257.524,-1935.703;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;215;-3390.035,-5015.35;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;123;-1365.406,-2134.914;Inherit;False;111;Flicker;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;224;-3423.943,-4672.364;Inherit;False;Property;_CameraFadeAlphaMin;CameraFadeAlphaMin;39;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;217;-3465.361,-4852.964;Inherit;False;Property;_CameraFadeEndPos;CameraFadeEndPos;38;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-3470.361,-4765.964;Inherit;False;Property;_CameraFadeStartPos;CameraFadeStartPos;37;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1918.661,-2465.285;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;195;-2285.297,-5372.097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-5080.598,-662.2226;Inherit;False;AnimateIntensity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-1506.335,-2346.789;Inherit;False;98;SoftEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;194;-2282.297,-5525.097;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-1348.206,-2052.782;Inherit;False;Property;_UseFlicker;UseFlicker;32;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-2825.817,-5417.695;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;209;-2823.043,-5777.903;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;198;-2117.297,-5524.097;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;141;-1051.604,-2047.903;Inherit;False;Property;_UseAnimateIntensity;UseAnimateIntensity;26;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-2627.327,-5780.117;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-1154.335,-2467.789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;223;-2935.644,-4976.889;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-1027.335,-2342.789;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;114;-3946.484,-1928.457;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;-1049.604,-2132.903;Inherit;False;137;AnimateIntensity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;199;-2651.131,-5489.951;Inherit;False;Property;_Length1;Length;43;0;Create;True;0;0;0;False;0;False;0.01;0;-5;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;200;-1925.297,-5785.097;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-3770.484,-1934.457;Inherit;False;DepthFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-847.3347,-2465.789;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;140;-730.6045,-2279.903;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;225;-2557.042,-4970.683;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;220;-2315.325,-4983.934;Inherit;False;CameraDistanceFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;-282.1191,-2361.642;Inherit;False;116;DepthFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-500.6045,-2438.903;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;201;-1785.297,-5785.097;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;202;-2310.131,-5616.951;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;207;-1397.359,-5630.143;Inherit;False;Property;_UseScaleOffset;UseScaleOffset;40;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;124;-60.89545,-2468.952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;-74.72997,-2279.435;Inherit;False;220;CameraDistanceFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;203;-1573.297,-5788.097;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;206;-1196.359,-5762.143;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-793.2656,-3161.296;Inherit;False;InstancedProperty;_Hue;Hue;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;222;219.67,-2456.835;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;-801.6658,-3074.796;Inherit;False;InstancedProperty;_Saturation;Saturation;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;232;-800.0656,-2978.296;Inherit;False;InstancedProperty;_Value;Value;5;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;229;-434.3655,-3089.796;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;227;293.3706,-2614.974;Inherit;False;InstancedProperty;_Alpha;Alpha;6;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-288.8335,-2904.086;Inherit;False;Property;_Emissive;Emissive;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;127;421.2851,-2457.123;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;204;-891.5977,-5794.306;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;233;-36.8335,-3006.086;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;651.7706,-2563.773;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;128;-664.1191,-2843.642;Inherit;False;Property;_Color;Color;3;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;208;665.4818,-2335.785;Inherit;False;204;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;52;987.1651,-2829.447;Float;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;982.1058,-2727.455;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sanrio/B2/LightShaftHSV;False;False;False;False;True;True;True;True;True;True;True;True;False;True;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;52;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;32;0;30;1
WireConnection;32;1;30;2
WireConnection;34;0;30;3
WireConnection;34;1;30;4
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;38;0;34;0
WireConnection;38;1;39;0
WireConnection;11;0;7;1
WireConnection;11;1;7;2
WireConnection;41;0;33;0
WireConnection;37;0;34;0
WireConnection;37;1;36;0
WireConnection;40;0;41;0
WireConnection;40;1;38;0
WireConnection;42;0;33;0
WireConnection;42;1;37;0
WireConnection;58;0;56;2
WireConnection;14;0;9;0
WireConnection;14;1;11;0
WireConnection;12;0;7;3
WireConnection;12;1;7;4
WireConnection;154;0;153;1
WireConnection;154;1;153;2
WireConnection;155;0;153;3
WireConnection;155;1;153;4
WireConnection;16;0;12;0
WireConnection;16;1;17;0
WireConnection;22;0;14;0
WireConnection;43;0;35;0
WireConnection;43;1;42;0
WireConnection;156;0;154;0
WireConnection;156;1;149;0
WireConnection;19;0;12;0
WireConnection;19;1;20;0
WireConnection;44;0;35;0
WireConnection;44;1;40;0
WireConnection;57;0;58;0
WireConnection;57;1;56;2
WireConnection;57;2;59;0
WireConnection;160;0;155;0
WireConnection;160;1;158;0
WireConnection;21;0;22;0
WireConnection;21;1;19;0
WireConnection;157;0;156;0
WireConnection;157;1;160;0
WireConnection;60;0;57;0
WireConnection;60;1;62;0
WireConnection;60;2;63;0
WireConnection;15;0;14;0
WireConnection;15;1;16;0
WireConnection;45;0;43;1
WireConnection;45;1;44;1
WireConnection;48;0;45;0
WireConnection;48;1;46;0
WireConnection;48;2;47;0
WireConnection;73;0;60;0
WireConnection;163;0;152;0
WireConnection;163;1;157;0
WireConnection;24;0;18;0
WireConnection;24;1;21;0
WireConnection;23;0;18;0
WireConnection;23;1;15;0
WireConnection;72;0;73;0
WireConnection;49;0;48;0
WireConnection;25;0;23;1
WireConnection;25;1;24;1
WireConnection;169;0;163;1
WireConnection;169;1;170;0
WireConnection;169;2;171;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;26;2;28;0
WireConnection;173;0;169;0
WireConnection;89;0;88;0
WireConnection;101;0;100;0
WireConnection;103;0;101;0
WireConnection;103;1;102;0
WireConnection;91;0;88;0
WireConnection;91;1;89;0
WireConnection;77;0;76;0
WireConnection;77;1;78;0
WireConnection;29;0;26;0
WireConnection;174;0;173;0
WireConnection;104;0;103;0
WireConnection;92;0;91;0
WireConnection;92;4;90;0
WireConnection;79;0;77;0
WireConnection;79;1;80;0
WireConnection;105;1;104;0
WireConnection;81;0;75;0
WireConnection;81;1;79;0
WireConnection;93;0;92;0
WireConnection;180;0;181;0
WireConnection;180;1;182;0
WireConnection;106;0;105;0
WireConnection;179;0;81;0
WireConnection;179;1;180;0
WireConnection;95;0;93;0
WireConnection;131;0;129;0
WireConnection;96;0;95;0
WireConnection;96;1;94;0
WireConnection;82;0;179;0
WireConnection;64;0;60;0
WireConnection;190;0;205;0
WireConnection;132;0;131;0
WireConnection;132;1;130;0
WireConnection;109;0;106;0
WireConnection;109;3;107;0
WireConnection;196;0;190;1
WireConnection;83;0;82;0
WireConnection;110;0;109;0
WireConnection;110;1;108;0
WireConnection;97;0;96;0
WireConnection;66;0;64;0
WireConnection;134;1;132;0
WireConnection;98;0;97;0
WireConnection;111;0;110;0
WireConnection;192;0;186;0
WireConnection;210;0;196;0
WireConnection;136;0;134;1
WireConnection;136;3;135;0
WireConnection;136;4;133;0
WireConnection;112;0;113;0
WireConnection;215;0;214;0
WireConnection;215;1;213;0
WireConnection;85;0;68;0
WireConnection;85;1;86;0
WireConnection;195;0;189;1
WireConnection;195;1;189;3
WireConnection;137;0;136;0
WireConnection;194;0;188;1
WireConnection;194;1;188;3
WireConnection;193;0;192;0
WireConnection;193;1;191;0
WireConnection;209;0;196;0
WireConnection;209;1;210;0
WireConnection;209;2;211;0
WireConnection;198;0;194;0
WireConnection;198;1;195;0
WireConnection;197;0;209;0
WireConnection;197;1;193;0
WireConnection;119;0;85;0
WireConnection;119;1;118;0
WireConnection;223;0;215;0
WireConnection;223;1;217;0
WireConnection;223;2;218;0
WireConnection;223;3;224;0
WireConnection;121;1;123;0
WireConnection;121;2;122;0
WireConnection;114;0;112;0
WireConnection;200;0;197;0
WireConnection;200;1;198;0
WireConnection;116;0;114;0
WireConnection;120;0;119;0
WireConnection;120;1;121;0
WireConnection;140;1;142;0
WireConnection;140;2;141;0
WireConnection;225;0;223;0
WireConnection;220;0;225;0
WireConnection;139;0;120;0
WireConnection;139;1;140;0
WireConnection;201;0;200;0
WireConnection;202;0;188;2
WireConnection;202;1;199;0
WireConnection;124;0;139;0
WireConnection;124;1;126;0
WireConnection;203;0;201;0
WireConnection;203;1;202;0
WireConnection;203;2;201;1
WireConnection;206;1;203;0
WireConnection;206;2;207;0
WireConnection;222;0;124;0
WireConnection;222;1;221;0
WireConnection;229;0;230;0
WireConnection;229;1;231;0
WireConnection;229;2;232;0
WireConnection;127;0;222;0
WireConnection;204;0;206;0
WireConnection;233;0;229;0
WireConnection;233;1;234;0
WireConnection;228;0;227;0
WireConnection;228;1;127;0
WireConnection;0;2;233;0
WireConnection;0;9;228;0
WireConnection;0;11;208;0
ASEEND*/
//CHKSM=B386C3E9CE2C7E24C1085F2B83504DBABB5F852D