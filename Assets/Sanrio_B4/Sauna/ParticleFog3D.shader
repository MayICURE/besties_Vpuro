// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RAKURAIWORKS/ParticleFog3D"
{
	Properties
	{
		_Opacity("Opacity", Range( 0 , 1)) = 1
		_Color1("Color1", Color) = (0,0,0,0)
		[NoScaleOffset]_ParticleTexture("ParticleTexture", 2D) = "white" {}
		_FogDensity("FogDensity", Float) = 1
		[Toggle]_UseSoftParticle("UseSoftParticle", Float) = 0
		_SoftParticleIntensity("SoftParticleIntensity", Float) = 4
		_FogDistanceFadeStartPos("FogDistanceFade StartPos", Float) = 5
		_FogDistanceFadeEndPos("FogDistanceFade EndPos", Float) = 2
		[NoScaleOffset]_1stNoiseTex("1stNoiseTex", 3D) = "white" {}
		_1stNoiseTexTiling("1stNoiseTex Tiling", Vector) = (0.1,0.1,0.1,0)
		_1stNoiseTexScroll("1stNoiseTex Scroll", Vector) = (0.1,0.1,0.1,0)
		_1stNoiseStepMin("1stNoiseStepMin", Range( 0 , 1)) = 0
		_1stNoiseStepMax("1stNoiseStepMax", Range( 0 , 1)) = 1
		[Toggle]_UseHeightFade("UseHeightFade", Float) = 1
		_HeightFadeMin("HeightFadeMin", Float) = 0
		_HeightFadeMax("HeightFadeMax", Float) = 20
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float4 _Color1;
		uniform float _1stNoiseStepMin;
		uniform float _1stNoiseStepMax;
		uniform sampler3D _1stNoiseTex;
		uniform float3 _1stNoiseTexTiling;
		uniform float3 _1stNoiseTexScroll;
		uniform sampler2D _ParticleTexture;
		uniform float _FogDensity;
		uniform float _FogDistanceFadeEndPos;
		uniform float _FogDistanceFadeStartPos;
		uniform float _HeightFadeMin;
		uniform float _HeightFadeMax;
		uniform float _UseHeightFade;
		uniform float _Opacity;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _SoftParticleIntensity;
		uniform float _UseSoftParticle;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float smoothstepResult9 = smoothstep( _1stNoiseStepMin , _1stNoiseStepMax , saturate( tex3D( _1stNoiseTex, ( ( ( ase_worldPos * _1stNoiseTexTiling ) + ( _1stNoiseTexScroll * _Time.y ) ) + float3( 0,0,0 ) ) ).a ));
			float Noise1st13 = smoothstepResult9;
			float AppendNoise29 = Noise1st13;
			float3 appendResult127 = (float3(i.vertexColor.r , i.vertexColor.g , i.vertexColor.b));
			o.Emission = ( _Color1 * AppendNoise29 * float4( appendResult127 , 0.0 ) ).rgb;
			float2 uv_ParticleTexture30 = i.uv_texcoord;
			float smoothstepResult59 = smoothstep( _FogDistanceFadeEndPos , _FogDistanceFadeStartPos , distance( _WorldSpaceCameraPos , ase_worldPos ));
			float DistanceMask48 = smoothstepResult59;
			float smoothstepResult64 = smoothstep( _HeightFadeMin , _HeightFadeMax , ase_worldPos.y);
			float lerpResult70 = lerp( 1.0 , saturate( smoothstepResult64 ) , _UseHeightFade);
			float HeightFade69 = lerpResult70;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth51 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth51 = abs( ( screenDepth51 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _SoftParticleIntensity ) );
			float SoftParticle53 = saturate( distanceDepth51 );
			float lerpResult130 = lerp( 1.0 , SoftParticle53 , _UseSoftParticle);
			o.Alpha = ( ( ( ( saturate( ( tex2D( _ParticleTexture, uv_ParticleTexture30 ).a * _FogDensity ) ) * i.vertexColor.a * AppendNoise29 ) * DistanceMask48 ) * HeightFade69 * _Opacity ) * lerpResult130 );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18935
1920;0;1920;1019;4295.896;473.9718;2.297889;True;True
Node;AmplifyShaderEditor.Vector3Node;5;-6142.851,-1704.796;Inherit;False;Property;_1stNoiseTexTiling;1stNoiseTex Tiling;11;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;101;-6109.746,-2736.859;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;60;-6133.985,-980.0348;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;7;-6138.851,-1531.796;Inherit;False;Property;_1stNoiseTexScroll;1stNoiseTex Scroll;12;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-5654.339,-1716.972;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-5669.724,-1407.767;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-5465.339,-1716.972;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-5298.728,-1622.537;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TexturePropertyNode;79;-5458.523,-2064.3;Inherit;True;Property;_1stNoiseTex;1stNoiseTex;10;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;LockedToTexture3D;Texture3D;-1;0;2;SAMPLER3D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;1;-5101.672,-1743.146;Inherit;True;Property;_1stNoiseTexs;1stNoiseTexs;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-4596.83,-1422.37;Inherit;False;Property;_1stNoiseStepMax;1stNoiseStepMax;14;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;10;-4755.131,-1642.571;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-4597.23,-1516.67;Inherit;False;Property;_1stNoiseStepMin;1stNoiseStepMin;13;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;9;-4282.531,-1643.271;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-5235.775,1290.445;Inherit;False;1784.45;416.2102;Comment;10;48;47;46;45;43;42;41;40;39;59;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-5189.564,2467.693;Inherit;False;Property;_HeightFadeMin;HeightFadeMin;27;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-3989.533,-1648.271;Inherit;False;Noise1st;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-5182.215,2557.994;Inherit;False;Property;_HeightFadeMax;HeightFadeMax;28;0;Create;True;0;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;63;-5220.014,2308.092;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceCameraPos;40;-5185.774,1349.036;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldPosInputsNode;39;-5112.435,1527.655;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;49;-5229.755,1796.076;Inherit;False;1159;345;Comment;4;53;52;51;50;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-4792.634,1460.056;Inherit;False;Property;_FogDistanceFadeEndPos;FogDistanceFade EndPos;8;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;64;-4617.361,2357.343;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-5218.802,360.2859;Inherit;True;Property;_ParticleTexture;ParticleTexture;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;32;-5060.361,590.9534;Inherit;False;Property;_FogDensity;FogDensity;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-4795.234,1548.456;Inherit;False;Property;_FogDistanceFadeStartPos;FogDistanceFade StartPos;7;0;Create;True;0;0;0;False;0;False;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;28;-3653.559,-53.49298;Inherit;False;13;Noise1st;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;42;-4780.934,1349.555;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-5179.754,2026.076;Inherit;False;Property;_SoftParticleIntensity;SoftParticleIntensity;6;0;Create;True;0;0;0;False;0;False;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;59;-4468.662,1349.808;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-4356.243,2252.929;Inherit;False;Constant;_Float0;Float 0;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-4346.243,2451.929;Inherit;False;Property;_UseHeightFade;UseHeightFade;26;1;[Toggle];Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;67;-4370.687,2357.118;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-4685.361,466.9534;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;29;-3180.628,-51.71505;Inherit;False;AppendNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;51;-4816.889,1908.396;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;52;-4524.754,1907.076;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-4113.956,2335.875;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;34;-4500.361,577.9534;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;48;-3694.325,1340.445;Inherit;False;DistanceMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-4475.361,468.9534;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;37;-4490.361,784.9534;Inherit;False;29;AppendNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;-4032.516,628.1345;Inherit;False;48;DistanceMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;69;-3882.855,2331.875;Inherit;False;HeightFade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-4143.362,468.9534;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-4313.754,1901.076;Inherit;False;SoftParticle;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;57;-3310.016,837.6345;Inherit;False;53;SoftParticle;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;131;-3174.867,714.7261;Inherit;False;Constant;_Float2;Float 2;28;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-3169.867,954.7261;Inherit;False;Property;_UseSoftParticle;UseSoftParticle;5;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;74;-3827.352,664.0964;Inherit;False;69;HeightFade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-3659.648,730.8969;Inherit;False;Property;_Opacity;Opacity;0;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-3791.516,471.1345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-2849.901,384.4812;Inherit;False;29;AppendNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;130;-2956.867,721.7261;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;127;-4227.532,819.3036;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;58;-2864.473,-3.235748;Inherit;False;Property;_Color1;Color1;1;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;56;-3365.016,470.6345;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-5597.927,-541.3891;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-4310.324,1505.445;Inherit;False;Property;_FogDistanceFalloff;FogDistanceFalloff;9;0;Create;True;0;0;0;False;0;False;1;1;1;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-5573.221,-856.1035;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-4021.856,-2663.907;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-3415.711,-319.303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-4511.856,-2335.907;Inherit;False;Property;_DisplacementScale;DisplacementScale;23;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;119;-5191.249,-852.9983;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;118;-5390.72,-690.6699;Inherit;False;112;Displacement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;102;-6130.746,-2400.859;Inherit;False;Property;_DisplacementNoiseTexScroll;DisplacementNoiseTex Scroll;22;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;21;-4522.612,-657.1009;Inherit;False;Property;_2ndNoiseStepMin;2ndNoiseStepMin;18;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-4515.713,-565.401;Inherit;False;Property;_2ndNoiseStepMax;2ndNoiseStepMax;19;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-5384.221,-856.1035;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;128;-2711.003,597.6607;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;98;-2382.901,288.4812;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;45;-4192.324,1345.445;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;18;-6044.553,-618.532;Inherit;False;Property;_2ndNoiseTexScroll;2ndNoiseTex Scroll;17;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;107;-5223.079,-2765.033;Inherit;True;Property;_TextureSample0;Texture Sample 0;7;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;111;-4403.938,-2665.158;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;122;-2379.498,33.58777;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-4382.982,-2514.048;Inherit;False;Constant;_Float1;Float 1;27;0;Create;True;0;0;0;False;0;False;0.3;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-5490.223,-1432.628;Inherit;False;112;Displacement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;105;-5586.746,-2738.859;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-5791.131,-2429.654;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.Vector3Node;100;-6134.746,-2573.859;Inherit;False;Property;_DisplacementNoiseTexTiling;DisplacementNoiseTex Tiling;21;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;19;-5020.554,-882.2769;Inherit;True;Property;_2ndNoiseTexs;2ndNoiseTexs;11;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;LockedToTexture3D;False;Object;-1;Auto;Texture3D;8;0;SAMPLER3D;;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-5775.746,-2738.859;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SmoothstepOpNode;23;-4201.412,-782.4009;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;97;-2867.901,191.4812;Inherit;False;Property;_Color2;Color2;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;112;-3779.941,-2671.158;Inherit;False;Displacement;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;47;-3965.325,1343.445;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;-3652.532,49.56306;Inherit;False;24;Noise2nd;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;80;-5394.461,-1078.363;Inherit;True;Property;_2ndNoiseTex;2ndNoiseTex;15;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;LockedToTexture3D;Texture3D;-1;0;2;SAMPLER3D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;109;-4718.638,-2538.557;Inherit;False;Property;_DisplacementNoiseNoiseStepMin;DisplacementNoiseNoiseStepMin;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;16;-6056.553,-789.5322;Inherit;False;Property;_2ndNoiseTexTiling;2ndNoiseTex Tiling;16;0;Create;True;0;0;0;False;0;False;0.1,0.1,0.1;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;108;-4876.539,-2664.458;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-4719.238,-2445.257;Inherit;False;Property;_DisplacementNoiseNoiseStepMax;DisplacementNoiseNoiseStepMax;25;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;106;-5579.93,-3086.187;Inherit;True;Property;_DisplacementNoiseTex;DisplacementNoiseTex;20;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;None;None;False;white;LockedToTexture3D;Texture3D;-1;0;2;SAMPLER3D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-4225.982,-2661.048;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;24;-3908.413,-787.4009;Inherit;False;Noise2nd;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;20;-4663.614,-780.4009;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-1179.865,230.6092;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;RAKURAIWORKS/ParticleFog3D;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;101;0
WireConnection;4;1;5;0
WireConnection;62;0;7;0
WireConnection;62;1;60;0
WireConnection;6;0;4;0
WireConnection;6;1;62;0
WireConnection;82;0;6;0
WireConnection;1;0;79;0
WireConnection;1;1;82;0
WireConnection;10;0;1;4
WireConnection;9;0;10;0
WireConnection;9;1;11;0
WireConnection;9;2;12;0
WireConnection;13;0;9;0
WireConnection;64;0;63;2
WireConnection;64;1;65;0
WireConnection;64;2;66;0
WireConnection;42;0;40;0
WireConnection;42;1;39;0
WireConnection;59;0;42;0
WireConnection;59;1;41;0
WireConnection;59;2;43;0
WireConnection;67;0;64;0
WireConnection;31;0;30;4
WireConnection;31;1;32;0
WireConnection;29;0;28;0
WireConnection;51;0;50;0
WireConnection;52;0;51;0
WireConnection;70;0;71;0
WireConnection;70;1;67;0
WireConnection;70;2;72;0
WireConnection;48;0;59;0
WireConnection;33;0;31;0
WireConnection;69;0;70;0
WireConnection;36;0;33;0
WireConnection;36;1;34;4
WireConnection;36;2;37;0
WireConnection;53;0;52;0
WireConnection;54;0;36;0
WireConnection;54;1;55;0
WireConnection;130;0;131;0
WireConnection;130;1;57;0
WireConnection;130;2;132;0
WireConnection;127;0;34;1
WireConnection;127;1;34;2
WireConnection;127;2;34;3
WireConnection;56;0;54;0
WireConnection;56;1;74;0
WireConnection;56;2;126;0
WireConnection;61;0;18;0
WireConnection;61;1;60;0
WireConnection;15;0;101;0
WireConnection;15;1;16;0
WireConnection;115;0;120;0
WireConnection;115;1;116;0
WireConnection;26;0;28;0
WireConnection;26;1;27;0
WireConnection;119;0;17;0
WireConnection;17;0;15;0
WireConnection;17;1;61;0
WireConnection;128;0;56;0
WireConnection;128;1;130;0
WireConnection;98;0;58;0
WireConnection;98;1;97;0
WireConnection;98;2;99;0
WireConnection;107;0;106;0
WireConnection;107;1;105;0
WireConnection;111;0;108;0
WireConnection;111;1;109;0
WireConnection;111;2;110;0
WireConnection;122;0;58;0
WireConnection;122;1;99;0
WireConnection;122;2;127;0
WireConnection;105;0;103;0
WireConnection;105;1;104;0
WireConnection;104;0;102;0
WireConnection;104;1;60;0
WireConnection;19;0;80;0
WireConnection;19;1;119;0
WireConnection;103;0;101;0
WireConnection;103;1;100;0
WireConnection;23;0;20;0
WireConnection;23;1;21;0
WireConnection;23;2;22;0
WireConnection;112;0;115;0
WireConnection;47;0;45;0
WireConnection;47;1;46;0
WireConnection;108;0;107;4
WireConnection;120;0;111;0
WireConnection;120;1;121;0
WireConnection;24;0;23;0
WireConnection;20;0;19;4
WireConnection;0;2;122;0
WireConnection;0;9;128;0
ASEEND*/
//CHKSM=D2519C77068F23F0E7B0C24489720C6A8687AD5B