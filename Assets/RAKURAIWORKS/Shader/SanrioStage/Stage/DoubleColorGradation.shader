// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/Stage/DoubleColorGradation"
{
	Properties
	{
		_Gradation1("Gradation1", Color) = (1,0.75,0.9843439,0)
		_UVPower("UV Power", Float) = 2.5
		_Gradation2("Gradation2", Color) = (0.5235849,0.8566347,1,0)
		_Rotate("Rotate", Range( 0 , 2)) = 0
		_EmissiveBoost("EmissiveBoost", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _Rotate;
		uniform float _UVPower;
		uniform float4 _Gradation1;
		uniform float4 _Gradation2;
		uniform float _EmissiveBoost;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 color18 = IsGammaSpace() ? float4(1,1,1,0) : float4(1,1,1,0);
			float cos21 = cos( ( _Rotate * UNITY_PI ) );
			float sin21 = sin( ( _Rotate * UNITY_PI ) );
			float2 rotator21 = mul( i.uv_texcoord - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
			float temp_output_3_0 = pow( rotator21.y , _UVPower );
			float temp_output_5_0 = pow( ( 1.0 - rotator21.y ) , _UVPower );
			float smoothstepResult15 = smoothstep( 0.0 , 1.0 , saturate( ( temp_output_3_0 + temp_output_5_0 ) ));
			float4 lerpResult16 = lerp( color18 , float4( 0.15,0.15,0.15,0 ) , smoothstepResult15);
			float4 temp_output_25_0 = ( saturate( ( lerpResult16 + ( ( _Gradation1 * temp_output_3_0 ) + ( temp_output_5_0 * _Gradation2 ) ) ) ) * _EmissiveBoost );
			o.Albedo = temp_output_25_0.rgb;
			o.Emission = temp_output_25_0.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
442;1;1920;1018;2792.563;1792.846;3.951749;True;True
Node;AmplifyShaderEditor.RangedFloatNode;23;-2616.707,239.7479;Inherit;False;Property;_Rotate;Rotate;3;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PiNode;24;-2296.048,214.5768;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;1;-2368.761,-162.3949;Inherit;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RotatorNode;21;-1978.961,-159.9815;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;22;-1673.444,-102.6906;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;6;-1383.369,94.58923;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-1357.369,-36.41077;Inherit;False;Property;_UVPower;UV Power;1;0;Create;True;0;0;0;False;0;False;2.5;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;3;-1128.369,-155.4108;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;5;-1146.369,117.5892;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-774.0197,-381.253;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;8;-1103.369,-340.4108;Inherit;False;Property;_Gradation1;Gradation1;0;0;Create;True;0;0;0;False;0;False;1,0.75,0.9843439,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;14;-524.0149,-376.8961;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-1102.492,379.3812;Inherit;False;Property;_Gradation2;Gradation2;2;0;Create;True;0;0;0;False;0;False;0.5235849,0.8566347,1,0;0.5235849,0.8566347,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-782.2238,-100.7402;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;18;-115.0149,-530.8961;Inherit;False;Constant;_Color;Color;1;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-788.7235,239.8598;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;15;-304.0149,-362.8961;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;42.42862,65.2443;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;16;183.9851,-311.8961;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0.15,0.15,0.15,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;19;580.9825,-47.50822;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;20;890.4932,-36.46918;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;881.3054,221.4822;Inherit;False;Property;_EmissiveBoost;EmissiveBoost;4;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1126.305,35.48218;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2039.108,-69.11221;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Sanrio/DoubleColorGradation;False;False;False;False;True;True;True;True;True;True;False;True;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;23;0
WireConnection;21;0;1;0
WireConnection;21;2;24;0
WireConnection;22;0;21;0
WireConnection;6;0;22;1
WireConnection;3;0;22;1
WireConnection;3;1;4;0
WireConnection;5;0;6;0
WireConnection;5;1;4;0
WireConnection;13;0;3;0
WireConnection;13;1;5;0
WireConnection;14;0;13;0
WireConnection;10;0;8;0
WireConnection;10;1;3;0
WireConnection;11;0;5;0
WireConnection;11;1;9;0
WireConnection;15;0;14;0
WireConnection;12;0;10;0
WireConnection;12;1;11;0
WireConnection;16;0;18;0
WireConnection;16;2;15;0
WireConnection;19;0;16;0
WireConnection;19;1;12;0
WireConnection;20;0;19;0
WireConnection;25;0;20;0
WireConnection;25;1;26;0
WireConnection;0;0;25;0
WireConnection;0;2;25;0
ASEEND*/
//CHKSM=D3D52AC3AA88E61235A7318D391C1EC00B48618C