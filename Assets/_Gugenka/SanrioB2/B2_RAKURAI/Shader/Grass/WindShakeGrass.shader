// Upgrade NOTE: upgraded instancing buffer 'SanrioB2WindShakeGrass' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/B2/WindShakeGrass"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_GrassHue("GrassHue", Range( 0 , 1)) = 0
		[NoScaleOffset]_NoiseMap("NoiseMap", 2D) = "white" {}
		_TilingAndScroll("TilingAndScroll", Vector) = (0.001,0.005,-0.04,-0.04)
		_WindMaskMin("WindMaskMin", Range( 0 , 1)) = 0
		_WindMaskMax("WindMaskMax", Range( 0 , 1)) = 1
		_WindStrength("WindStrength", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "AlphaTest+0" "DisableBatching" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha noshadow noambient novertexlights nodynlightmap nodirlightmap nofog noforwardadd vertex:vertexDataFunc 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _NoiseMap;
		uniform float4 _TilingAndScroll;
		uniform float _WindMaskMin;
		uniform float _WindMaskMax;
		uniform float _WindStrength;
		uniform sampler2D _MainTex;
		uniform float _Cutoff = 0.5;

		UNITY_INSTANCING_BUFFER_START(SanrioB2WindShakeGrass)
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr SanrioB2WindShakeGrass
			UNITY_DEFINE_INSTANCED_PROP(float, _GrassHue)
#define _GrassHue_arr SanrioB2WindShakeGrass
		UNITY_INSTANCING_BUFFER_END(SanrioB2WindShakeGrass)


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float2 appendResult7 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult8 = (float2(_TilingAndScroll.x , _TilingAndScroll.y));
			float2 appendResult9 = (float2(_TilingAndScroll.z , _TilingAndScroll.w));
			float smoothstepResult19 = smoothstep( _WindMaskMin , _WindMaskMax , v.texcoord.xy.y);
			float WindMask23 = smoothstepResult19;
			float4 tex2DNode13 = tex2Dlod( _NoiseMap, float4( ( ( appendResult7 * appendResult8 ) + ( appendResult9 * ( _Time.y + WindMask23 ) ) ), 0, 0.0) );
			float2 appendResult14 = (float2(tex2DNode13.r , tex2DNode13.g));
			float Wind18 = (0.0 + (saturate( length( appendResult14 ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
			float temp_output_27_0 = ( ( Wind18 * _WindStrength ) * WindMask23 );
			float3 appendResult29 = (float3(temp_output_27_0 , 0.0 , temp_output_27_0));
			v.vertex.xyz += appendResult29;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float4 tex2DNode2 = tex2D( _MainTex, uv_MainTex );
			float4 color42 = IsGammaSpace() ? float4(0.075,0.3,0.3,0) : float4(0.006571403,0.07323897,0.07323897,0);
			float _GrassHue_Instance = UNITY_ACCESS_INSTANCED_PROP(_GrassHue_arr, _GrassHue);
			float3 hsvTorgb45 = HSVToRGB( float3(_GrassHue_Instance,0.6,1.0) );
			float4 lerpResult40 = lerp( color42 , float4( hsvTorgb45 , 0.0 ) , (0.0 + (i.uv_texcoord.y - 0.3) * (1.0 - 0.0) / (1.0 - 0.3)));
			o.Emission = ( tex2DNode2 * lerpResult40 ).rgb;
			o.Alpha = 1;
			clip( tex2DNode2.a - _Cutoff );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
7;91;1920;928;2095.981;1301.129;1;True;True
Node;AmplifyShaderEditor.RangedFloatNode;20;-3111.968,-329.7125;Inherit;False;Property;_WindMaskMin;WindMaskMin;5;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-2893.16,-528.031;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-2895.968,-241.7125;Inherit;False;Property;_WindMaskMax;WindMaskMax;6;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;19;-2536.968,-507.7125;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;23;-2302.335,-477.432;Inherit;False;WindMask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;5;-4760.56,-754.69;Inherit;False;Property;_TilingAndScroll;TilingAndScroll;4;0;Create;True;0;0;0;False;0;False;0.001,0.005,-0.04,-0.04;0.001,0.005,-0.04,-0.04;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;4;-4774.56,-982.691;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;33;-4951.782,-249.15;Inherit;False;23;WindMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;6;-4926.56,-436.69;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-4584.395,-463.3444;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-4467.56,-698.69;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-4489.56,-953.691;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-4480.602,-807.949;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-4248.56,-941.691;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-4246.56,-672.69;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-4072.56,-844.691;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;13;-3809.256,-871.659;Inherit;True;Property;_NoiseMap;NoiseMap;3;1;[NoScaleOffset];Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;14;-3425.56,-838.691;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LengthOpNode;15;-3256.56,-838.691;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;16;-3007.56,-837.691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;17;-2613.183,-832.2701;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;18;-2362.392,-843.204;Inherit;False;Wind;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1795.057,-1035.134;Inherit;False;InstancedProperty;_GrassHue;GrassHue;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;36;-1741.01,-783.5768;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;26;-1152.245,35.68628;Inherit;False;Property;_WindStrength;WindStrength;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;24;-1141.542,-82.18161;Inherit;False;18;Wind;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;44;-1402.911,-754.4859;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0.3;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-831.2451,-40.31372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;-1420.538,-1295.898;Inherit;False;Constant;_Color0;Color0;8;0;Create;True;0;0;0;False;0;False;0.075,0.3,0.3,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.HSVToRGBNode;45;-1425.057,-1031.134;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.6;False;2;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;28;-896.2451,147.6863;Inherit;False;23;WindMask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;40;-943.5386,-789.8986;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1139.858,-572.1733;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-637.2451,8.686279;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;29;-435.3228,32.4354;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-269.5752,-467.8918;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;144,-191;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Sanrio/B2/WindShakeGrass;False;False;False;False;True;True;False;True;True;True;False;True;False;True;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Masked;0.5;True;False;0;False;TransparentCutout;;AlphaTest;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;3;2
WireConnection;19;1;20;0
WireConnection;19;2;21;0
WireConnection;23;0;19;0
WireConnection;31;0;6;0
WireConnection;31;1;33;0
WireConnection;9;0;5;3
WireConnection;9;1;5;4
WireConnection;7;0;4;1
WireConnection;7;1;4;3
WireConnection;8;0;5;1
WireConnection;8;1;5;2
WireConnection;11;0;7;0
WireConnection;11;1;8;0
WireConnection;10;0;9;0
WireConnection;10;1;31;0
WireConnection;12;0;11;0
WireConnection;12;1;10;0
WireConnection;13;1;12;0
WireConnection;14;0;13;1
WireConnection;14;1;13;2
WireConnection;15;0;14;0
WireConnection;16;0;15;0
WireConnection;17;0;16;0
WireConnection;18;0;17;0
WireConnection;44;0;36;2
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;45;0;46;0
WireConnection;40;0;42;0
WireConnection;40;1;45;0
WireConnection;40;2;44;0
WireConnection;27;0;25;0
WireConnection;27;1;28;0
WireConnection;29;0;27;0
WireConnection;29;2;27;0
WireConnection;34;0;2;0
WireConnection;34;1;40;0
WireConnection;0;2;34;0
WireConnection;0;10;2;4
WireConnection;0;11;29;0
ASEEND*/
//CHKSM=D516AAC7D383DEC0921CB2FE858BEA65AFE6A4AC