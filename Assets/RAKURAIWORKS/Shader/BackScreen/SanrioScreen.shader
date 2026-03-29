// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/BackScreen"
{
	Properties
	{
		[Toggle]_UseScreenEffect("UseScreenEffect", Float) = 1
		_MainTex("MainTex", 2D) = "white" {}
		_BaseBrightness("BaseBrightness", Range( 0 , 1)) = 0
		_StripePower("StripePower", Float) = 1
		_FlickerScale("FlickerScale", Range( 0 , 1)) = 1
		_FlickerPowerMin("Flicker PowerMin", Range( 0 , 1)) = 0.9
		_FlickerTimeScale("Flicker TimeScale", Float) = 15
		_FlickerSeed("FlickerSeed", Float) = 0
		_GrainStrength1("GrainStrength", Float) = 50
		_Stripe("Stripe", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float _BaseBrightness;
		uniform sampler2D _Stripe;
		uniform float4 _Stripe_ST;
		uniform float _StripePower;
		uniform float _FlickerTimeScale;
		uniform float _FlickerSeed;
		uniform float _FlickerPowerMin;
		uniform float _FlickerScale;
		uniform float _GrainStrength1;
		uniform float _UseScreenEffect;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode30 = tex2D( _MainTex, uv_MainTex );
			float2 uv_Stripe = i.uv_texcoord * _Stripe_ST.xy + _Stripe_ST.zw;
			float lerpResult32 = lerp( _BaseBrightness , 1.0 , tex2D( _Stripe, uv_Stripe ).r);
			float Stripe8 = lerpResult32;
			float mulTime17 = _Time.y * _FlickerTimeScale;
			float2 appendResult19 = (float2(mulTime17 , _FlickerSeed));
			float dotResult4_g7 = dot( trunc( appendResult19 ) , float2( 12.9898,78.233 ) );
			float lerpResult10_g7 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g7 ) * 43758.55 ) ));
			float Flicker27 = ( (_FlickerPowerMin + ((0.0 + (lerpResult10_g7 - 0.25) * (1.0 - 0.0) / (0.75 - 0.25)) - 0.0) * (1.0 - _FlickerPowerMin) / (1.0 - 0.0)) * _FlickerScale );
			float mulTime68 = _Time.y * 10.0;
			float GrainUV73 = ( fmod( mulTime68 , 7200.0 ) * ( ( 4.0 + i.uv_texcoord.x ) * ( i.uv_texcoord.y + 4.0 ) ) );
			float temp_output_55_0 = ( fmod( ( ( fmod( GrainUV73 , 13.0 ) + 1.0 ) * ( fmod( GrainUV73 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 );
			float Grain59 = ( 1.0 - ( temp_output_55_0 * _GrainStrength1 ) );
			float4 lerpResult78 = lerp( tex2DNode30 , ( tex2DNode30 * ( ( ( Stripe8 * _StripePower ) * Flicker27 ) * Grain59 ) ) , _UseScreenEffect);
			o.Emission = lerpResult78.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;36;1920;982;1632.408;1141.867;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;39;-5977.506,-3164.316;Inherit;False;1904.158;457.9991;Comment;11;73;72;71;70;69;68;67;65;64;63;66;Grain;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;63;-5460.543,-2822.315;Float;False;Constant;_Float2;Float 1;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-5464.543,-3106.316;Float;False;Constant;_Float4;Float 3;1;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;65;-5229.543,-3114.316;Float;False;Constant;_Float5;Float 4;1;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;66;-5792.974,-3014.575;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;68;-5069.113,-3069.28;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-5264.543,-2991.315;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;67;-5267.543,-2888.314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;70;-4787.18,-2998.103;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;7200;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;-5056.543,-2930.314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;72;-4484.186,-2995.79;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;15;-1844.981,-2327.869;Inherit;False;2400.206;398.0544;Comment;12;27;26;25;24;23;22;21;20;19;18;17;16;RandomFlicker;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-5994.626,-2642.791;Inherit;False;1857.811;1112.645;Comment;22;62;61;60;59;58;57;56;55;54;53;52;51;50;49;48;47;46;45;44;43;42;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-1794.981,-2277.869;Inherit;False;Property;_FlickerTimeScale;Flicker TimeScale;6;0;Create;True;0;0;0;False;0;False;15;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-4297.347,-3002.041;Float;True;GrainUV;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1603.735,-2165.461;Inherit;False;Property;_FlickerSeed;FlickerSeed;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;17;-1577.981,-2272.869;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-5926.825,-2019.772;Float;False;Constant;_Float18;Float 17;1;0;Create;True;0;0;0;False;0;False;123;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-5944.626,-2592.791;Inherit;False;73;GrainUV;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;42;-5928.326,-2149.073;Inherit;False;73;GrainUV;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-5943.126,-2463.492;Float;False;Constant;_Float6;Float 5;1;0;Create;True;0;0;0;False;0;False;13;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;48;-5727.728,-2524.493;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;47;-5711.426,-2080.773;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-5905.525,-1882.172;Float;False;Constant;_Float20;Float 19;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-5921.825,-2325.892;Float;False;Constant;_Float11;Float 10;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1180.28,-2267.704;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;50;-5542.525,-2046.173;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TruncOpNode;20;-1021.483,-2266.869;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;49;-5542.825,-2426.892;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-5410.526,-1920.991;Float;False;Constant;_Float7;Float 6;1;0;Create;True;0;0;0;False;0;False;0.01;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;-5372.725,-2173.592;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;21;-875.5883,-2266.869;Inherit;False;Random Range;-1;;7;7b754edb8aebbfb4a9ace907af661cfc;0;3;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-773.0526,-2045.815;Inherit;False;Property;_FlickerPowerMin;Flicker PowerMin;5;0;Create;True;0;0;0;False;0;False;0.9;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-914.3684,-1051.492;Inherit;False;Property;_BaseBrightness;BaseBrightness;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;23;-652.2671,-2267.789;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.75;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;34;-448.2226,-858.3547;Inherit;True;Property;_Stripe;Stripe;9;0;Create;True;0;0;0;False;0;False;-1;181268322d3298b4b9a91d971f2e807b;181268322d3298b4b9a91d971f2e807b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;-5243.526,-1741.991;Float;False;Constant;_Float8;Float 7;1;0;Create;True;0;0;0;False;0;False;0.005;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;53;-5117.727,-2090.592;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-262.4351,-2088.544;Inherit;False;Property;_FlickerScale;FlickerScale;4;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;24;-408.1461,-2269.248;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.9;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-4951.234,-1947.536;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-5246.313,-1646.147;Float;False;Property;_GrainStrength1;GrainStrength;8;0;Create;True;0;0;0;False;0;False;50;34.84;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;32;8.912842,-958.2234;Inherit;True;3;0;FLOAT;0.73;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;366.2527,-910.7874;Inherit;False;Stripe;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-4784.229,-1807.094;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;101.9462,-2265.345;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;10;-1569.181,-419.3282;Inherit;False;8;Stripe;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;334.2713,-2271.721;Inherit;False;Flicker;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1558.791,-317.6502;Inherit;False;Property;_StripePower;StripePower;3;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;58;-4561.718,-1746.572;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-1211.791,-413.6502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-1205.308,-242.7036;Inherit;False;27;Flicker;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;59;-4360.814,-1809.735;Float;False;Grain;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-925.004,-363.5533;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;77;-842.9204,-233.7949;Inherit;False;59;Grain;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;30;-1411.533,-761.0972;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-634.9204,-383.7949;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-369.4314,-439.0844;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-263.0901,-269.4931;Inherit;False;Property;_UseScreenEffect;UseScreenEffect;0;1;[Toggle];Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;78;32.52466,-506.5214;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;60;-4540.584,-2152.456;Inherit;False;VertGrain;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;62;-4939.611,-2122.245;Inherit;False;Constant;_Float3;Float 2;19;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-4745.294,-2150.245;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;835.1818,-587.918;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;Sanrio/BackScreen;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;68;0;65;0
WireConnection;69;0;64;0
WireConnection;69;1;66;1
WireConnection;67;0;66;2
WireConnection;67;1;63;0
WireConnection;70;0;68;0
WireConnection;71;0;69;0
WireConnection;71;1;67;0
WireConnection;72;0;70;0
WireConnection;72;1;71;0
WireConnection;73;0;72;0
WireConnection;17;0;16;0
WireConnection;48;0;43;0
WireConnection;48;1;41;0
WireConnection;47;0;42;0
WireConnection;47;1;44;0
WireConnection;19;0;17;0
WireConnection;19;1;18;0
WireConnection;50;0;47;0
WireConnection;50;1;45;0
WireConnection;20;0;19;0
WireConnection;49;0;48;0
WireConnection;49;1;46;0
WireConnection;52;0;49;0
WireConnection;52;1;50;0
WireConnection;21;1;20;0
WireConnection;23;0;21;0
WireConnection;53;0;52;0
WireConnection;53;1;51;0
WireConnection;24;0;23;0
WireConnection;24;3;22;0
WireConnection;55;0;53;0
WireConnection;55;1;54;0
WireConnection;32;0;33;0
WireConnection;32;2;34;1
WireConnection;8;0;32;0
WireConnection;57;0;55;0
WireConnection;57;1;56;0
WireConnection;26;0;24;0
WireConnection;26;1;25;0
WireConnection;27;0;26;0
WireConnection;58;0;57;0
WireConnection;11;0;10;0
WireConnection;11;1;12;0
WireConnection;59;0;58;0
WireConnection;28;0;11;0
WireConnection;28;1;29;0
WireConnection;76;0;28;0
WireConnection;76;1;77;0
WireConnection;31;0;30;0
WireConnection;31;1;76;0
WireConnection;78;0;30;0
WireConnection;78;1;31;0
WireConnection;78;2;79;0
WireConnection;60;0;61;0
WireConnection;61;0;55;0
WireConnection;61;1;62;0
WireConnection;0;2;78;0
ASEEND*/
//CHKSM=CC15E94B77CBBBFDE89573AC53F0B852E0E51892