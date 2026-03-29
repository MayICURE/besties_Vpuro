// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/UnderLightSurface"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("Cull Mode", Float) = 2
		[HDR]_Color("Color", Color) = (1,1,1,0)
		_Alpha("Alpha", Range( 0 , 1)) = 1
		_SeamFade("SeamFade", Range( 0 , 1)) = 1
		_SeamFadeWidthMin("SeamFadeWidthMin", Range( 0 , 1)) = 0.5
		_SeamFadeWidthMax("SeamFadeWidthMax", Range( 0 , 1)) = 0.51
		_UnderColorBoost("UnderColorBoost", Float) = 50
		_UnderFade("UnderFade", Range( 0 , 1)) = 0.05
		_RimEdgeFade("Rim EdgeFade", Range( 0 , 1)) = 0
		_UpperPosLimitMin("UpperPosLimitMin", Range( 0 , 1)) = 0
		_UpperPosLimitMax("UpperPosLimitMax", Range( 0 , 1)) = 1
		[NoScaleOffset]_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseTexTilingandScroll("NoiseTex Tiling and Scroll", Vector) = (5,0.001,0.1,0)
		_StepMin("StepMin", Range( 0 , 1)) = 0
		_StepMax("StepMax", Range( 0 , 1)) = 1
		_SubNoiseIntensity("SubNoise Intensity", Range( 0 , 1)) = 0
		[NoScaleOffset]_SubNoise("SubNoise", 2D) = "black" {}
		_SubNoiseTilingandScroll("SubNoise Tiling and Scroll", Vector) = (5,0.001,0.1,0)
		_SubNoiseStepMin("SubNoiseStepMin", Range( 0 , 1)) = 0
		_SubNoiseStepMax("SubNoiseStepMax", Range( 0 , 1)) = 1
		[Toggle]_UseScanline("UseScanline", Float) = 0
		_ScanPower("ScanPower", Range( 0 , 1)) = 0.3
		_ScanTiling("ScanTiling", Float) = 1
		_ScanSpeed("ScanSpeed", Float) = 1
		[Toggle]_UseFlicker("UseFlicker", Float) = 0
		_FlickerScale("FlickerScale", Range( 0 , 1)) = 1
		_FlickerPowerMin("Flicker PowerMin", Range( 0 , 1)) = 0.9
		_FlickerTimeScale("Flicker TimeScale", Float) = 15
		_FlickerSeed("FlickerSeed", Float) = 0
		[Toggle]_UseGrain("UseGrain", Float) = 0
		_GrainStrength("GrainStrength", Float) = 50
		[Toggle]_UseScaleOffset("UseScaleOffset", Float) = 1
		_Width("Width", Range( -1 , 1)) = 0
		_Length("Length", Range( 0.01 , 5)) = 0.01
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float3 worldNormal;
			half ASEVFace : VFACE;
			INTERNAL_DATA
		};

		uniform float _CullMode;
		uniform float _Width;
		uniform float _Length;
		uniform float _UseScaleOffset;
		uniform float _UnderColorBoost;
		uniform float4 _Color;
		uniform float _SeamFadeWidthMin;
		uniform float _SeamFadeWidthMax;
		uniform float _SeamFade;
		uniform float _Alpha;
		uniform float _UpperPosLimitMin;
		uniform float _UpperPosLimitMax;
		uniform float _StepMin;
		uniform float _StepMax;
		uniform sampler2D _NoiseTex;
		uniform float4 _NoiseTexTilingandScroll;
		uniform float _SubNoiseStepMin;
		uniform float _SubNoiseStepMax;
		uniform sampler2D _SubNoise;
		uniform float4 _SubNoiseTilingandScroll;
		uniform float _SubNoiseIntensity;
		uniform float _UnderFade;
		uniform float _RimEdgeFade;
		uniform float _FlickerTimeScale;
		uniform float _FlickerSeed;
		uniform float _FlickerPowerMin;
		uniform float _FlickerScale;
		uniform float _UseFlicker;
		uniform float _GrainStrength;
		uniform float _UseGrain;
		uniform float _ScanTiling;
		uniform float _ScanSpeed;
		uniform float _ScanPower;
		uniform float _UseScanline;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 appendResult134 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.z));
			float3 ase_vertexNormal = v.normal.xyz;
			float2 appendResult136 = (float2(ase_vertexNormal.x , ase_vertexNormal.z));
			float2 break139 = ( ( v.texcoord.xy.y * ( (-0.03 + (_Width - -1.0) * (0.03 - -0.03) / (1.0 - -1.0)) * 100.0 ) ) * ( appendResult134 + appendResult136 ) );
			float3 appendResult140 = (float3(break139.x , ( ase_vertex3Pos.y * _Length ) , break139.y));
			float3 VertexOffset141 = appendResult140;
			float3 lerpResult175 = lerp( float3( 0,0,0 ) , VertexOffset141 , _UseScaleOffset);
			v.vertex.xyz += lerpResult175;
			v.vertex.w = 1;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float smoothstepResult185 = smoothstep( 0.0 , 1.0 , pow( ( 1.0 - i.uv_texcoord.y ) , 10.0 ));
			o.Emission = ( ( ( smoothstepResult185 * _UnderColorBoost ) * _Color ) + _Color ).rgb;
			float smoothstepResult239 = smoothstep( _SeamFadeWidthMin , _SeamFadeWidthMax , ( 1.0 - distance( i.uv_texcoord.x , 0.5 ) ));
			float lerpResult242 = lerp( 1.0 , smoothstepResult239 , _SeamFade);
			float smoothstepResult230 = smoothstep( _UpperPosLimitMin , _UpperPosLimitMax , ( 1.0 - i.uv_texcoord.y ));
			float smoothstepResult16 = smoothstep( 0.0 , 1.0 , ( 1.0 - i.uv_texcoord.y ));
			float2 appendResult40 = (float2(_NoiseTexTilingandScroll.x , _NoiseTexTilingandScroll.y));
			float2 temp_output_38_0 = ( i.uv_texcoord * appendResult40 );
			float2 appendResult41 = (float2(_NoiseTexTilingandScroll.z , _NoiseTexTilingandScroll.w));
			float smoothstepResult59 = smoothstep( _StepMin , _StepMax , ( tex2D( _NoiseTex, ( temp_output_38_0 + ( appendResult41 * _Time.y ) ) ).r * tex2D( _NoiseTex, ( ( temp_output_38_0 * float2( 0.85,0.85 ) ) + ( ( appendResult41 * ( _Time.y * -1.0 ) ) * float2( 0.85,0.85 ) ) ) ).r ));
			float smoothstepResult206 = smoothstep( 0.2 , 1.0 , i.uv_texcoord.y);
			float2 appendResult192 = (float2(_SubNoiseTilingandScroll.x , _SubNoiseTilingandScroll.y));
			float2 temp_output_195_0 = ( i.uv_texcoord * appendResult192 );
			float2 appendResult191 = (float2(_SubNoiseTilingandScroll.z , _SubNoiseTilingandScroll.w));
			float smoothstepResult210 = smoothstep( _SubNoiseStepMin , _SubNoiseStepMax , ( tex2D( _SubNoise, ( temp_output_195_0 + ( appendResult191 * _Time.y ) ) ).r * tex2D( _SubNoise, ( ( temp_output_195_0 * float2( 0.85,0.85 ) ) + ( ( appendResult191 * ( _Time.y * -1.0 ) ) * float2( 0.85,0.85 ) ) ) ).r ));
			float MainAlpha212 = ( saturate( smoothstepResult206 ) * smoothstepResult210 );
			float MainAlpha49 = saturate( ( ( saturate( smoothstepResult16 ) * smoothstepResult59 ) - ( MainAlpha212 * _SubNoiseIntensity ) ) );
			float smoothstepResult27 = smoothstep( 0.0 , _UnderFade , i.uv_texcoord.y);
			float UnderFade29 = saturate( smoothstepResult27 );
			float3 ase_worldNormal = i.worldNormal;
			float3 switchResult71 = (((i.ASEVFace>0)?(ase_worldNormal):(-ase_worldNormal)));
			float fresnelNdotV5 = dot( switchResult71, i.viewDir );
			float fresnelNode5 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV5, 5.0 ) );
			float smoothstepResult10 = smoothstep( _RimEdgeFade , 1.0 , ( 1.0 - saturate( fresnelNode5 ) ));
			float SoftEdge22 = saturate( smoothstepResult10 );
			float mulTime78 = _Time.y * _FlickerTimeScale;
			float2 appendResult84 = (float2(mulTime78 , _FlickerSeed));
			float dotResult4_g7 = dot( trunc( appendResult84 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g7 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g7 ) * 43758.55 ) ));
			float Flicker74 = ( (_FlickerPowerMin + ((0.0 + (lerpResult10_g7 - 0.25) * (1.0 - 0.0) / (0.5 - 0.25)) - 0.0) * (1.0 - _FlickerPowerMin) / (1.0 - 0.0)) * _FlickerScale );
			float lerpResult88 = lerp( 1.0 , Flicker74 , _UseFlicker);
			float mulTime97 = _Time.y * 10.0;
			float GrainUV101 = ( fmod( mulTime97 , 7200.0 ) * ( ( 4.0 + i.uv_texcoord.x ) * ( i.uv_texcoord.y + 4.0 ) ) );
			float temp_output_118_0 = ( fmod( ( ( fmod( GrainUV101 , 13.0 ) + 1.0 ) * ( fmod( GrainUV101 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 );
			float Grain124 = ( 1.0 - ( temp_output_118_0 * _GrainStrength ) );
			float lerpResult127 = lerp( 1.0 , Grain124 , _UseGrain);
			float mulTime154 = _Time.y * _ScanSpeed;
			float Scan160 = saturate( ( ( 1.0 - frac( ( ( i.uv_texcoord.x * _ScanTiling ) + fmod( mulTime154 , 7200.0 ) ) ) ) + ( 1.0 - _ScanPower ) ) );
			float lerpResult165 = lerp( 1.0 , Scan160 , _UseScanline);
			o.Alpha = ( lerpResult242 * saturate( ( _Alpha * ( smoothstepResult230 * ( ( ( ( ( MainAlpha49 * UnderFade29 ) * SoftEdge22 ) * lerpResult88 ) * lerpResult127 ) * lerpResult165 ) ) ) ) );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
87;515;1920;640;-1125.923;2039.785;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;219;-6424.48,-2472.84;Inherit;False;3459.153;2218.059;Comment;57;188;189;187;193;190;192;191;44;194;55;39;195;197;37;196;198;40;41;54;213;199;201;38;56;200;45;63;64;202;204;51;14;43;57;205;207;208;206;53;209;52;17;210;16;61;58;60;211;212;59;18;218;46;217;215;216;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;187;-6374.48,-837.2727;Inherit;False;Property;_SubNoiseTilingandScroll;SubNoise Tiling and Scroll;17;0;Create;True;0;0;0;False;0;False;5,0.001,0.1,0;5,0.001,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;189;-6101.545,-584.1236;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-6066.862,-449.1845;Inherit;False;Constant;_Float8;Float 8;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;90;-6404.699,-4225.119;Inherit;False;1904.158;457.9991;Comment;11;101;100;99;98;97;96;95;94;93;92;91;Grain;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;193;-6159.021,-968.4758;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;190;-5872.862,-520.9846;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;192;-6083.06,-818.3418;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;191;-6069.06,-716.3418;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;221;-6697.074,-4139.071;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-5869.637,-1547.034;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;44;-5904.32,-1681.973;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-5714.963,-573.9846;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;39;-6177.255,-1935.122;Inherit;False;Property;_NoiseTexTilingandScroll;NoiseTex Tiling and Scroll;12;0;Create;True;0;0;0;False;0;False;5,0.001,0.1,0;5,0.001,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;91;-5656.737,-4175.119;Float;False;Constant;_Float4;Float 4;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-5891.737,-4167.119;Float;False;Constant;_Float3;Float 3;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;195;-5703.326,-878.5968;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;94;-5887.737,-3883.119;Float;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;37;-5961.796,-2066.325;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;41;-5871.835,-1814.191;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;97;-5496.306,-4130.083;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-5675.637,-1618.834;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;96;-5691.737,-4052.119;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;95;-5694.737,-3949.118;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;196;-5547.813,-559.4687;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;197;-5710.445,-715.5248;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;198;-5543.813,-746.4688;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;40;-5885.835,-1916.191;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;213;-5486.787,-1041.024;Inherit;True;Property;_SubNoise;SubNoise;16;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;black;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-5517.738,-1671.834;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-5506.102,-1976.446;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;201;-5394.247,-660.7977;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;199;-5389.322,-834.2249;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FmodOpNode;99;-5214.373,-4058.906;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;7200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;-5483.737,-3991.118;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;204;-5135.787,-697.8237;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-5513.22,-1813.374;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;64;-5350.587,-1657.318;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;202;-5146.188,-976.0248;Inherit;True;Property;_TextureSample2;Texture Sample 2;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-5346.587,-1844.318;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0.85,0.85;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;100;-4911.379,-4056.593;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1797.396,-2494.816;Inherit;False;2370.755;451.4976;Comment;11;6;70;7;71;5;8;11;9;10;20;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;72;-6393.92,-4711.226;Inherit;False;2400.206;398.0544;Comment;12;84;83;82;81;80;79;78;77;76;75;74;73;RandomFlicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;200;-5728.06,-1324.991;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;102;-6400.744,-3714.132;Inherit;False;1857.811;1112.645;Comment;22;124;123;122;121;120;119;118;117;116;115;114;113;112;111;110;109;108;107;106;105;104;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;205;-4825.364,-813.1849;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;206;-5308.718,-1273.922;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;14;-5530.835,-2422.84;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;207;-5078.691,-473.7806;Inherit;False;Property;_SubNoiseStepMin;SubNoiseStepMin;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;57;-5197.022,-1758.647;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-5192.098,-1932.074;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;208;-5075.691,-370.7806;Inherit;False;Property;_SubNoiseStepMax;SubNoiseStepMax;19;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;101;-4724.54,-4062.844;Float;True;GrainUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-6343.92,-4661.226;Inherit;False;Property;_FlickerTimeScale;Flicker TimeScale;27;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;51;-5289.563,-2138.873;Inherit;True;Property;_NoiseTex;NoiseTex;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WorldNormalVector;6;-1747.396,-2408.687;Inherit;False;False;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;83;-6152.674,-4548.818;Inherit;False;Property;_FlickerSeed;FlickerSeed;28;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;209;-5083.064,-1272.711;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;52;-4948.963,-2073.874;Inherit;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;103;-6332.943,-3091.113;Float;False;Constant;_Float17;Float 17;1;0;Create;True;0;0;0;False;0;False;123;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;105;-6350.744,-3664.132;Inherit;False;101;GrainUV;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;53;-4938.562,-1795.673;Inherit;True;Property;_TextureSample1;Texture Sample 1;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;173;-6391.745,-5296.427;Inherit;False;1843.389;421.5645;Comment;14;157;152;154;151;162;159;161;155;158;163;156;150;160;170;;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;17;-5324.796,-2373.043;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;104;-6334.444,-3220.414;Inherit;False;101;GrainUV;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;78;-6126.92,-4656.226;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;210;-4569.691,-813.7808;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-6349.244,-3534.833;Float;False;Constant;_Float5;Float 5;1;0;Create;True;0;0;0;False;0;False;13;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;70;-1501.445,-2354.199;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;7;-1409.459,-2231.319;Inherit;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.FmodOpNode;109;-6133.846,-3595.834;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;108;-6117.544,-3152.114;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-4878.466,-1468.63;Inherit;False;Property;_StepMax;StepMax;14;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-6297.999,-5022.918;Inherit;False;Property;_ScanSpeed;ScanSpeed;23;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SwitchByFaceNode;71;-1312.863,-2444.816;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;60;-4881.466,-1571.63;Inherit;False;Property;_StepMin;StepMin;13;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;-4628.139,-1911.034;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;211;-4294.374,-1261.61;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-5729.219,-4651.061;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-5111.493,-2371.771;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-6327.943,-3397.233;Float;False;Constant;_Float10;Float 10;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-6311.643,-2953.513;Float;False;Constant;_Float19;Float 19;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;34;-1795.689,-2011.594;Inherit;False;1408.656;435.115;Comment;6;24;25;27;28;29;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;18;-4885.839,-2370.56;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;24;-1745.689,-1961.594;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;218;-4193.456,-967.134;Inherit;False;Property;_SubNoiseIntensity;SubNoise Intensity;15;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;170;-6341.745,-5241.296;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;152;-6124.091,-5127.836;Inherit;False;Property;_ScanTiling;ScanTiling;22;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;5;-1112.287,-2391.366;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;111;-5948.643,-3117.514;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;59;-4372.466,-1911.63;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;112;-5948.943,-3498.233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;212;-4156.189,-1267.993;Inherit;True;MainAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;154;-6080.999,-5019.918;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TruncOpNode;80;-5565.919,-4650.226;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FunctionNode;73;-5423.401,-4650.226;Inherit;False;Random Range;-1;;7;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-5778.843,-3244.933;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1520.833,-1692.479;Inherit;False;Property;_UnderFade;UnderFade;7;0;Create;True;0;0;0;False;0;False;0.05;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;217;-3821.259,-1312.261;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-5933.206,-5246.427;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;-5816.644,-2992.332;Float;False;Constant;_Float6;Float 6;1;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;8;-864.2659,-2391.319;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;25;-1460.926,-1913.604;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-4097.149,-2359.459;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;162;-5840.712,-5018.288;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;7200;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;82;-5201.206,-4651.146;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.5;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;215;-3627.066,-2328.401;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;9;-715.0437,-2389.886;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-5321.991,-4429.172;Inherit;False;Property;_FlickerPowerMin;Flicker PowerMin;26;0;Create;True;0;0;0;False;0;False;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;27;-1194.355,-1913.603;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;116;-5523.845,-3161.933;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;115;-5649.644,-2813.332;Float;False;Constant;_Float7;Float 7;1;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;159;-5657.997,-5182.918;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-857.0428,-2276.885;Inherit;False;Property;_RimEdgeFade;Rim EdgeFade;8;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FractNode;155;-5489.355,-5181.961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-4811.374,-4471.901;Inherit;False;Property;_FlickerScale;FlickerScale;25;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;77;-4957.084,-4652.604;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.9;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;216;-3478.59,-2324.799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;123;-5652.431,-2717.488;Float;False;Property;_GrainStrength;GrainStrength;30;0;Create;True;0;0;0;False;0;False;50;34.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;118;-5357.352,-3018.877;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;28;-900.0328,-1912.895;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;161;-5621.556,-4989.862;Inherit;False;Property;_ScanPower;ScanPower;21;0;Create;True;0;0;0;False;0;False;0.3;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;10;-493.0436,-2388.886;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;163;-5325.355,-4991.961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-611.0328,-1915.895;Inherit;False;UnderFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;158;-5340.355,-5181.961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-5190.347,-2878.435;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;-3189.327,-2334.786;Inherit;True;MainAlpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-218.6409,-2387.26;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;174;-1813.887,-3416.449;Inherit;False;2386.129;763.7258;Comment;18;144;133;129;146;135;171;132;134;136;145;137;143;148;138;147;139;140;141;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-4465.376,-4651.901;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;144;-1763.887,-3042.545;Inherit;False;Property;_Width;Width;32;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;400.8178,-459.2046;Inherit;False;49;MainAlpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;349.3591,-2389.26;Inherit;False;SoftEdge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;-4967.836,-2817.913;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;396.5499,-370.336;Inherit;False;29;UnderFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-4217.714,-4638.324;Inherit;False;Flicker;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-5148.355,-5180.961;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;135;-831.4575,-2922.124;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;87;1049.883,-205.4029;Inherit;False;74;Flicker;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;1040.883,-97.40294;Inherit;False;Property;_UseFlicker;UseFlicker;24;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;763.6816,-220.3769;Inherit;False;22;SoftEdge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;133;-949.4575,-3186.124;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;124;-4766.932,-2881.076;Float;False;Grain;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;150;-4955.355,-5181.961;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-1417.978,-2768.723;Inherit;False;Constant;_Float9;Float 9;15;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;171;-1390.156,-3052.4;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;-0.03;False;4;FLOAT;0.03;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;129;-1495.567,-3366.449;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;708.3806,-443.7921;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;223;2123.779,-616.6186;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;128;1473.651,-85.15704;Inherit;False;Property;_UseGrain;UseGrain;29;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-4772.355,-5186.961;Inherit;True;Scan;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;88;1292.882,-194.4029;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;126;1494.651,-273.157;Inherit;False;124;Grain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-1164.978,-2953.723;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;136;-624.4575,-2908.124;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RelayNode;132;-1255.157,-3319.524;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;134;-621.4575,-3061.124;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1166.681,-440.3769;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;137;-456.4576,-3060.124;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;178;1106.554,-1208.58;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;143;-966.4875,-3316.145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;167;1845.769,-93.74513;Inherit;False;Property;_UseScanline;UseScanline;20;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;166;1870.769,-189.7451;Inherit;False;160;Scan;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RelayNode;225;2443.323,-600.4535;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;86;1486.545,-414.3237;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;127;1716.651,-246.157;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;227;2611.023,-778.0535;Inherit;False;Property;_UpperPosLimitMin;UpperPosLimitMin;9;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;2610.228,-704.1732;Inherit;False;Property;_UpperPosLimitMax;UpperPosLimitMax;10;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;229;2669.295,-609.3099;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;179;1357.346,-1160.774;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;138;-264.4575,-3321.124;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-987.2915,-3020.979;Inherit;False;Property;_Length;Length;33;0;Create;True;0;0;0;False;0;False;0.01;0;0.01;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;1843.652,-407.157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;165;2062.768,-263.7451;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;235;1276.332,-2012.116;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;237;1617.88,-1967.945;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;230;2999.668,-668.9153;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;164;2285.769,-407.7451;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;147;-649.2915,-3152.979;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;180;1552.393,-1157.481;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;139;-124.4578,-3321.124;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;234;3012.805,-761.8943;Inherit;False;Property;_Alpha;Alpha;2;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;228;3305.634,-490.5394;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;140;87.54231,-3324.124;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;185;1810.298,-1161.986;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;238;1912.88,-1965.945;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;240;1844.681,-1564.818;Inherit;False;Property;_SeamFadeWidthMax;SeamFadeWidthMax;5;0;Create;True;0;0;0;False;0;False;0.51;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;184;1830.99,-945.3842;Inherit;False;Property;_UnderColorBoost;UnderColorBoost;6;0;Create;True;0;0;0;False;0;False;50;50;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;1846.167,-1694.905;Inherit;False;Property;_SeamFadeWidthMin;SeamFadeWidthMin;4;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;3452.268,-608.4711;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;141;348.2413,-3327.333;Inherit;False;VertexOffset;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;244;2307.396,-1694.888;Inherit;False;Property;_SeamFade;SeamFade;3;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;239;2135.88,-1965.945;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;2237.809,-1166.756;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;12;1969.039,-832.4329;Inherit;False;Property;_Color;Color;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;243;2420.881,-2014.386;Inherit;False;Constant;_Float11;Float 11;32;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;233;3641.635,-616.8093;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;242;2625.396,-1899.888;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;142;2892.982,184.3215;Inherit;False;141;VertexOffset;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;176;2942.846,286.9917;Inherit;False;Property;_UseScaleOffset;UseScaleOffset;31;1;[Toggle];Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;181;2583.609,-1196.657;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;175;3267.394,99.18666;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;246;2391.177,-1884.711;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;92;-6354.699,-4150.41;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;222;4240.524,-918.9984;Float;False;Property;_CullMode;Cull Mode;0;1;[Enum];Create;True;0;0;1;UnityEngine.Rendering.CullMode;True;0;False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-5345.729,-3193.586;Inherit;False;Constant;_Float2;Float 2;19;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;120;-4946.702,-3223.797;Inherit;False;VertGrain;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;245;3851.829,-621.1483;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;182;2887.808,-892.4561;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;119;-5151.412,-3221.586;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;220;4240.865,-825.6057;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sanrio/UnderLightSurface;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;True;222;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;190;0;189;0
WireConnection;190;1;188;0
WireConnection;192;0;187;1
WireConnection;192;1;187;2
WireConnection;191;0;187;3
WireConnection;191;1;187;4
WireConnection;194;0;191;0
WireConnection;194;1;190;0
WireConnection;195;0;193;0
WireConnection;195;1;192;0
WireConnection;41;0;39;3
WireConnection;41;1;39;4
WireConnection;97;0;91;0
WireConnection;54;0;44;0
WireConnection;54;1;55;0
WireConnection;96;0;93;0
WireConnection;96;1;221;1
WireConnection;95;0;221;2
WireConnection;95;1;94;0
WireConnection;196;0;194;0
WireConnection;197;0;191;0
WireConnection;197;1;189;0
WireConnection;198;0;195;0
WireConnection;40;0;39;1
WireConnection;40;1;39;2
WireConnection;56;0;41;0
WireConnection;56;1;54;0
WireConnection;38;0;37;0
WireConnection;38;1;40;0
WireConnection;201;0;198;0
WireConnection;201;1;196;0
WireConnection;199;0;195;0
WireConnection;199;1;197;0
WireConnection;99;0;97;0
WireConnection;98;0;96;0
WireConnection;98;1;95;0
WireConnection;204;0;213;0
WireConnection;204;1;201;0
WireConnection;45;0;41;0
WireConnection;45;1;44;0
WireConnection;64;0;56;0
WireConnection;202;0;213;0
WireConnection;202;1;199;0
WireConnection;63;0;38;0
WireConnection;100;0;99;0
WireConnection;100;1;98;0
WireConnection;205;0;202;1
WireConnection;205;1;204;1
WireConnection;206;0;200;2
WireConnection;57;0;63;0
WireConnection;57;1;64;0
WireConnection;43;0;38;0
WireConnection;43;1;45;0
WireConnection;101;0;100;0
WireConnection;209;0;206;0
WireConnection;52;0;51;0
WireConnection;52;1;43;0
WireConnection;53;0;51;0
WireConnection;53;1;57;0
WireConnection;17;0;14;2
WireConnection;78;0;75;0
WireConnection;210;0;205;0
WireConnection;210;1;207;0
WireConnection;210;2;208;0
WireConnection;70;0;6;0
WireConnection;109;0;105;0
WireConnection;109;1;106;0
WireConnection;108;0;104;0
WireConnection;108;1;103;0
WireConnection;71;0;6;0
WireConnection;71;1;70;0
WireConnection;58;0;52;1
WireConnection;58;1;53;1
WireConnection;211;0;209;0
WireConnection;211;1;210;0
WireConnection;84;0;78;0
WireConnection;84;1;83;0
WireConnection;16;0;17;0
WireConnection;18;0;16;0
WireConnection;5;0;71;0
WireConnection;5;4;7;0
WireConnection;111;0;108;0
WireConnection;111;1;107;0
WireConnection;59;0;58;0
WireConnection;59;1;60;0
WireConnection;59;2;61;0
WireConnection;112;0;109;0
WireConnection;112;1;110;0
WireConnection;212;0;211;0
WireConnection;154;0;157;0
WireConnection;80;0;84;0
WireConnection;73;1;80;0
WireConnection;113;0;112;0
WireConnection;113;1;111;0
WireConnection;217;0;212;0
WireConnection;217;1;218;0
WireConnection;151;0;170;1
WireConnection;151;1;152;0
WireConnection;8;0;5;0
WireConnection;25;0;24;2
WireConnection;46;0;18;0
WireConnection;46;1;59;0
WireConnection;162;0;154;0
WireConnection;82;0;73;0
WireConnection;215;0;46;0
WireConnection;215;1;217;0
WireConnection;9;0;8;0
WireConnection;27;0;25;0
WireConnection;27;2;33;0
WireConnection;116;0;113;0
WireConnection;116;1;114;0
WireConnection;159;0;151;0
WireConnection;159;1;162;0
WireConnection;155;0;159;0
WireConnection;77;0;82;0
WireConnection;77;3;79;0
WireConnection;216;0;215;0
WireConnection;118;0;116;0
WireConnection;118;1;115;0
WireConnection;28;0;27;0
WireConnection;10;0;9;0
WireConnection;10;1;11;0
WireConnection;163;0;161;0
WireConnection;29;0;28;0
WireConnection;158;0;155;0
WireConnection;122;0;118;0
WireConnection;122;1;123;0
WireConnection;49;0;216;0
WireConnection;20;0;10;0
WireConnection;76;0;77;0
WireConnection;76;1;81;0
WireConnection;22;0;20;0
WireConnection;121;0;122;0
WireConnection;74;0;76;0
WireConnection;156;0;158;0
WireConnection;156;1;163;0
WireConnection;124;0;121;0
WireConnection;150;0;156;0
WireConnection;171;0;144;0
WireConnection;19;0;50;0
WireConnection;19;1;32;0
WireConnection;160;0;150;0
WireConnection;88;1;87;0
WireConnection;88;2;89;0
WireConnection;145;0;171;0
WireConnection;145;1;146;0
WireConnection;136;0;135;1
WireConnection;136;1;135;3
WireConnection;132;0;129;2
WireConnection;134;0;133;1
WireConnection;134;1;133;3
WireConnection;66;0;19;0
WireConnection;66;1;68;0
WireConnection;137;0;134;0
WireConnection;137;1;136;0
WireConnection;143;0;132;0
WireConnection;143;1;145;0
WireConnection;225;0;223;2
WireConnection;86;0;66;0
WireConnection;86;1;88;0
WireConnection;127;1;126;0
WireConnection;127;2;128;0
WireConnection;229;0;225;0
WireConnection;179;0;178;2
WireConnection;138;0;143;0
WireConnection;138;1;137;0
WireConnection;125;0;86;0
WireConnection;125;1;127;0
WireConnection;165;1;166;0
WireConnection;165;2;167;0
WireConnection;237;0;235;1
WireConnection;230;0;229;0
WireConnection;230;1;227;0
WireConnection;230;2;231;0
WireConnection;164;0;125;0
WireConnection;164;1;165;0
WireConnection;147;0;133;2
WireConnection;147;1;148;0
WireConnection;180;0;179;0
WireConnection;139;0;138;0
WireConnection;228;0;230;0
WireConnection;228;1;164;0
WireConnection;140;0;139;0
WireConnection;140;1;147;0
WireConnection;140;2;139;1
WireConnection;185;0;180;0
WireConnection;238;0;237;0
WireConnection;232;0;234;0
WireConnection;232;1;228;0
WireConnection;141;0;140;0
WireConnection;239;0;238;0
WireConnection;239;1;247;0
WireConnection;239;2;240;0
WireConnection;183;0;185;0
WireConnection;183;1;184;0
WireConnection;233;0;232;0
WireConnection;242;0;243;0
WireConnection;242;1;239;0
WireConnection;242;2;244;0
WireConnection;181;0;183;0
WireConnection;181;1;12;0
WireConnection;175;1;142;0
WireConnection;175;2;176;0
WireConnection;246;0;239;0
WireConnection;120;0;119;0
WireConnection;245;0;242;0
WireConnection;245;1;233;0
WireConnection;182;0;181;0
WireConnection;182;1;12;0
WireConnection;119;0;118;0
WireConnection;119;1;117;0
WireConnection;220;2;182;0
WireConnection;220;9;245;0
WireConnection;220;11;175;0
ASEEND*/
//CHKSM=6A6EAAA1928C1247841D133C2847882CABFDC67E