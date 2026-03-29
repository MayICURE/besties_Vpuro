// Upgrade NOTE: upgraded instancing buffer 'SanrioB2InstancingColorVariation' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sanrio/B2/InstancingColorVariation"
{
	Properties
	{
		[Toggle]_IsUnlit("IsUnlit", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		_Metallic("Metallic", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		_HueShift("HueShift", Range( -1 , 1)) = 0
		_SaturationShift("SaturationShift", Range( -1 , 1)) = 0
		_ValueShift("ValueShift", Range( -1 , 1)) = 0
		_Emission("Emission", 2D) = "black" {}
		[HDR]_EmissionColor("EmissionColor", Color) = (0,0,0,0)
		_HueShiftEmission("HueShiftEmission", 2D) = "black" {}
		[HDR]_HueShiftEmissionColor("HueShiftEmissionColor", Color) = (0,0,0,0)
		_EmissionHueShift("EmissionHueShift", Range( -1 , 1)) = 0
		_EmissionSaturationShift("EmissionSaturationShift", Range( -1 , 1)) = 0
		_EmissionValueShift("EmissionValueShift", Range( -1 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _MainTex;
		uniform float _IsUnlit;
		uniform sampler2D _Emission;
		uniform float4 _EmissionColor;
		uniform sampler2D _HueShiftEmission;
		uniform float4 _HueShiftEmissionColor;
		uniform float _Metallic;
		uniform float _Smoothness;

		UNITY_INSTANCING_BUFFER_START(SanrioB2InstancingColorVariation)
			UNITY_DEFINE_INSTANCED_PROP(float4, _MainTex_ST)
#define _MainTex_ST_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float4, _Emission_ST)
#define _Emission_ST_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float4, _HueShiftEmission_ST)
#define _HueShiftEmission_ST_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _HueShift)
#define _HueShift_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _SaturationShift)
#define _SaturationShift_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _ValueShift)
#define _ValueShift_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _EmissionHueShift)
#define _EmissionHueShift_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _EmissionSaturationShift)
#define _EmissionSaturationShift_arr SanrioB2InstancingColorVariation
			UNITY_DEFINE_INSTANCED_PROP(float, _EmissionValueShift)
#define _EmissionValueShift_arr SanrioB2InstancingColorVariation
		UNITY_INSTANCING_BUFFER_END(SanrioB2InstancingColorVariation)


		float3 HSVToRGB( float3 c )
		{
			float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
			float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
			return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
		}


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float _HueShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_HueShift_arr, _HueShift);
			float4 _MainTex_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_MainTex_ST_arr, _MainTex_ST);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST_Instance.xy + _MainTex_ST_Instance.zw;
			float3 hsvTorgb3 = RGBToHSV( tex2D( _MainTex, uv_MainTex ).rgb );
			float _SaturationShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_SaturationShift_arr, _SaturationShift);
			float _ValueShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_ValueShift_arr, _ValueShift);
			float3 hsvTorgb2 = HSVToRGB( float3(( _HueShift_Instance + hsvTorgb3.x ),saturate( ( _SaturationShift_Instance + hsvTorgb3.y ) ),saturate( ( _ValueShift_Instance + hsvTorgb3.z ) )) );
			float3 lerpResult17 = lerp( hsvTorgb2 , float3( 0,0,0 ) , _IsUnlit);
			o.Albedo = lerpResult17;
			float3 lerpResult19 = lerp( float3( 0,0,0 ) , hsvTorgb2 , _IsUnlit);
			float4 _Emission_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_Emission_ST_arr, _Emission_ST);
			float2 uv_Emission = i.uv_texcoord * _Emission_ST_Instance.xy + _Emission_ST_Instance.zw;
			float _EmissionHueShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionHueShift_arr, _EmissionHueShift);
			float4 _HueShiftEmission_ST_Instance = UNITY_ACCESS_INSTANCED_PROP(_HueShiftEmission_ST_arr, _HueShiftEmission_ST);
			float2 uv_HueShiftEmission = i.uv_texcoord * _HueShiftEmission_ST_Instance.xy + _HueShiftEmission_ST_Instance.zw;
			float3 hsvTorgb22 = RGBToHSV( tex2D( _HueShiftEmission, uv_HueShiftEmission ).rgb );
			float _EmissionSaturationShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionSaturationShift_arr, _EmissionSaturationShift);
			float _EmissionValueShift_Instance = UNITY_ACCESS_INSTANCED_PROP(_EmissionValueShift_arr, _EmissionValueShift);
			float3 hsvTorgb21 = HSVToRGB( float3(( _EmissionHueShift_Instance + hsvTorgb22.x ),saturate( ( _EmissionSaturationShift_Instance + hsvTorgb22.y ) ),saturate( ( _EmissionValueShift_Instance + hsvTorgb22.z ) )) );
			o.Emission = ( float4( lerpResult19 , 0.0 ) + ( ( tex2D( _Emission, uv_Emission ) * _EmissionColor ) + ( float4( hsvTorgb21 , 0.0 ) * _HueShiftEmissionColor ) ) ).rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
0;42;1906;977;2732.736;868.807;1.6;True;True
Node;AmplifyShaderEditor.SamplerNode;14;-3015.397,-37.65909;Inherit;True;Property;_HueShiftEmission;HueShiftEmission;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;22;-2684.665,-46.67126;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;23;-2747.419,-162.0107;Inherit;False;InstancedProperty;_EmissionValueShift;EmissionValueShift;13;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-2744.419,-270.0106;Inherit;False;InstancedProperty;_EmissionSaturationShift;EmissionSaturationShift;12;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-2342.243,-412.3348;Inherit;True;Property;_MainTex;MainTex;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;9;-2089.243,-507.3347;Inherit;False;InstancedProperty;_ValueShift;ValueShift;6;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-2741.419,-368.0106;Inherit;False;InstancedProperty;_EmissionHueShift;EmissionHueShift;11;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;-2278.163,160.6985;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-2086.243,-615.3347;Inherit;False;InstancedProperty;_SaturationShift;SaturationShift;5;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RGBToHSVNode;3;-1977.243,-408.3348;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;27;-2281.163,41.69855;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1621.243,-264.3348;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-2083.243,-713.3347;Inherit;False;InstancedProperty;_HueShift;HueShift;4;0;Create;True;0;0;0;False;0;False;0;0;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;30;-2117.163,177.6985;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;29;-2121.163,46.69855;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;26;-2283.163,-81.30145;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1625.243,-398.3348;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;32;-1736.101,674.1328;Inherit;False;Property;_EmissionColor;EmissionColor;8;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;11;-1451.642,-268.7754;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;21;-1846.061,6.971069;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;31;-1829.736,457.0941;Inherit;True;Property;_Emission;Emission;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;4;-1626.243,-529.3347;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;-1792.602,185.8038;Inherit;False;Property;_HueShiftEmissionColor;HueShiftEmissionColor;10;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;10;-1454.243,-390.3348;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.HSVToRGBNode;2;-1224.243,-415.3348;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1383.224,4.838078;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1319.101,488.1328;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-967.2443,-194.7177;Inherit;False;Property;_IsUnlit;IsUnlit;0;1;[Toggle];Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;19;-548.308,-243.9246;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;34;-1030.248,36.11331;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;20;-281.308,-190.9246;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-372.3722,136.708;Inherit;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;17;-657.2443,-407.7177;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-371.3722,27.70801;Inherit;False;Property;_Metallic;Metallic;2;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;203.0622,-416.9902;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Sanrio/B2/InstancingColorVariation;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;14;0
WireConnection;28;0;23;0
WireConnection;28;1;22;3
WireConnection;3;0;1;0
WireConnection;27;0;24;0
WireConnection;27;1;22;2
WireConnection;8;0;9;0
WireConnection;8;1;3;3
WireConnection;30;0;28;0
WireConnection;29;0;27;0
WireConnection;26;0;25;0
WireConnection;26;1;22;1
WireConnection;6;0;7;0
WireConnection;6;1;3;2
WireConnection;11;0;8;0
WireConnection;21;0;26;0
WireConnection;21;1;29;0
WireConnection;21;2;30;0
WireConnection;4;0;5;0
WireConnection;4;1;3;1
WireConnection;10;0;6;0
WireConnection;2;0;4;0
WireConnection;2;1;10;0
WireConnection;2;2;11;0
WireConnection;16;0;21;0
WireConnection;16;1;15;0
WireConnection;33;0;31;0
WireConnection;33;1;32;0
WireConnection;19;1;2;0
WireConnection;19;2;18;0
WireConnection;34;0;33;0
WireConnection;34;1;16;0
WireConnection;20;0;19;0
WireConnection;20;1;34;0
WireConnection;17;0;2;0
WireConnection;17;2;18;0
WireConnection;0;0;17;0
WireConnection;0;2;20;0
WireConnection;0;3;13;0
WireConnection;0;4;12;0
ASEEND*/
//CHKSM=A15874A23CA746DDF0E775492B39D9BCCBC46234