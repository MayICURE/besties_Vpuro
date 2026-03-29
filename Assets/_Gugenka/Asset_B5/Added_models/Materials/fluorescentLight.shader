// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "fluorescentLight"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_EmissionMap("EmissionMap", 2D) = "black" {}
		_MetallicGlossMap("MetallicGlossMap", 2D) = "white" {}
		_Noise("Noise", 2D) = "white" {}
		_Speed("Speed", Float) = 400
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
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _EmissionMap;
		uniform float4 _EmissionMap_ST;
		uniform sampler2D _Noise;
		uniform float _Speed;
		uniform sampler2D _MetallicGlossMap;
		uniform float4 _MetallicGlossMap_ST;


		float3 wpos3(  )
		{
			return mul(UNITY_MATRIX_M, float4(0,0,0,1));
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float2 uv_EmissionMap = i.uv_texcoord * _EmissionMap_ST.xy + _EmissionMap_ST.zw;
			float3 localwpos3 = wpos3();
			float3 temp_output_5_0 = ( localwpos3 + ( _Time.y / _Speed ) );
			float grayscale19 = (tex2D( _Noise, temp_output_5_0.xy ).rgb.r + tex2D( _Noise, temp_output_5_0.xy ).rgb.g + tex2D( _Noise, temp_output_5_0.xy ).rgb.b) / 3;
			o.Emission = ( tex2D( _EmissionMap, uv_EmissionMap ) * (0.3 + (grayscale19 - 0.0) * (1.5 - 0.3) / (1.0 - 0.0)) ).rgb;
			float2 uv_MetallicGlossMap = i.uv_texcoord * _MetallicGlossMap_ST.xy + _MetallicGlossMap_ST.zw;
			float4 tex2DNode13 = tex2D( _MetallicGlossMap, uv_MetallicGlossMap );
			o.Metallic = tex2DNode13.r;
			o.Smoothness = tex2DNode13.a;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
819;1025;1947;939;2043.864;-152.1356;1;True;True
Node;AmplifyShaderEditor.TimeNode;6;-2016.646,507.342;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-1942.189,670.0115;Inherit;False;Property;_Speed;Speed;4;0;Create;True;0;0;0;False;0;False;400;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;3;-1844.646,445.3419;Inherit;False;return mul(UNITY_MATRIX_M, float4(0,0,0,1))@;3;Create;0;wpos;True;False;0;;False;0;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;20;-1790.189,587.0115;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-1644.646,475.3419;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;18;-1495.808,609.7897;Inherit;True;Property;_Noise;Noise;3;0;Create;True;0;0;0;False;0;False;-1;None;09f6a0db39dab7e49adbf0930725c02f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;19;-1114.808,608.7897;Inherit;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-954,319.5;Inherit;True;Property;_EmissionMap;EmissionMap;1;0;Create;True;0;0;0;False;0;False;-1;None;f175d9d2efc407345b90d4551d85ca70;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;17;-803.9489,612.5318;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.3;False;4;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-226,361.5;Inherit;True;Property;_MetallicGlossMap;MetallicGlossMap;2;0;Create;True;0;0;0;False;0;False;-1;None;202de74d69b57104cad07454b5e5b076;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-596.0455,358.4813;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;4;-1326.646,472.3419;Inherit;False;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-511,31.5;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;None;5b9eadf231e7231459821f8937607826;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;207,12;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;fluorescentLight;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;20;0;6;2
WireConnection;20;1;21;0
WireConnection;5;0;3;0
WireConnection;5;1;20;0
WireConnection;18;1;5;0
WireConnection;19;0;18;0
WireConnection;17;0;19;0
WireConnection;7;0;2;0
WireConnection;7;1;17;0
WireConnection;4;0;5;0
WireConnection;0;0;1;0
WireConnection;0;2;7;0
WireConnection;0;3;13;0
WireConnection;0;4;13;4
ASEEND*/
//CHKSM=6E1D161E169524E1377D690D0831DBE1C3B2F17F