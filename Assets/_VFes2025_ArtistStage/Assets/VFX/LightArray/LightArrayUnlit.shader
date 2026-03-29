
Shader "VFes2025ArtistStage/LightArrayUnlit"
{
	Properties
	{
		_Color1st("Color 1st", Color) = (1,0,0,0)
		_Color1stIntensity("Color1st Intensity", Float) = 1
		_Color2nd("Color 2nd", Color) = (0,1,0,0)
		_Color2ndIntensity("Color2nd Intensity", Float) = 1
		_Color3rd("Color 3rd", Color) = (0,0,1,0)
		_Color3rdIntensity("Color3rd Intensity", Float) = 1
		_Speed("Speed", Float) = 1
		_Outer("Outer", Float) = 0.05
		_Inner("Inner", Float) = 1.5
		_FadeOut("FadeOut", Float) = 0.8
		_FadeIn("FadeIn", Float) = 1.1

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend Off
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityShaderVariables.cginc"


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _Color1st;
			uniform float _Color1stIntensity;
			uniform float4 _Color2nd;
			uniform float _Color2ndIntensity;
			uniform float _Speed;
			uniform float4 _Color3rd;
			uniform float _Color3rdIntensity;
			uniform float _Outer;
			uniform float _Inner;
			uniform float _FadeOut;
			uniform float _FadeIn;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_texcoord1.zw = v.ase_texcoord1.xy;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 texCoord1 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float mulTime16 = _Time.y * _Speed;
				float4 lerpResult5 = lerp( ( _Color1st * _Color1stIntensity ) , ( _Color2nd * _Color2ndIntensity ) , step( 0.3333 , frac( ( texCoord1.x + ( floor( mulTime16 ) * 0.33333 ) ) ) ));
				float4 lerpResult10 = lerp( lerpResult5 , ( _Color3rd * _Color3rdIntensity ) , step( 0.66 , frac( ( texCoord1.x + ( floor( mulTime16 ) * 0.33333 ) ) ) ));
				float mulTime58 = _Time.y * ( _Speed * -1.0 );
				float temp_output_66_0 = step( 0.66 , frac( ( texCoord1.x + ( floor( mulTime58 ) * 0.33333 ) ) ) );
				float2 texCoord89 = i.ase_texcoord1.zw * float2( 1,1 ) + float2( 0,0 );
				float2 UV290 = texCoord89;
				float smoothstepResult47 = smoothstep( 0.1 , 1.0 , ( 1.0 - distance( (UV290*2.0 + -1.0) , float2( 0,0 ) ) ));
				float temp_output_28_0 = frac( mulTime16 );
				float smoothstepResult29 = smoothstep( 0.0 , 1.0 , ( 1.0 - temp_output_28_0 ));
				float Anim40 = (_FadeOut + (smoothstepResult29 - 0.0) * (_FadeIn - _FadeOut) / (1.0 - 0.0));
				
				
				finalColor = ( ( lerpResult10 * (0.2 + (temp_output_66_0 - 0.0) * (1.0 - 0.2) / (1.0 - 0.0)) * (_Outer + (smoothstepResult47 - 0.0) * (_Inner - _Outer) / (1.0 - 0.0)) ) * Anim40 );
				return finalColor;
			}
			ENDCG
		}
	}
	
	Fallback "Unlit/Color"
}