// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Sanrio/Stage/UnlitWithShadows" {
	Properties {
	    [Enum(Baked,0,RealTime,1)]_GIMode("GlobalIllumination", int) = 0
		_Color ("Main Color", Color) = (1,1,1,1)
		[HideInInspector]_MainTex ("Base (RGB)", 2D) = "white" {}
		_Gradation1("Gradation1", Color) = (1,0.75,0.9843439,0)
		_UVPower("UV Power", Float) = 2.5
		_Gradation2("Gradation2", Color) = (0.5235849,0.8566347,1,0)
		_Contrast("Contrast",float) = 1.0
		_Rotate("Rotate", Range( 0 , 2)) = 0
		_EmissiveBoost("EmissiveBoost", Float) = 1
	}

	SubShader {
		Tags {"Queue" = "Geometry" "RenderType" = "Opaque"}

		Pass{
            Name "Meta"
            Tags{"LightMode"="Meta"}
            Cull Off

            CGPROGRAM
            #include "UnityStandardMeta.cginc"

			uniform float _Rotate;
			uniform float _UVPower;
			uniform float4 _Gradation1;
			uniform float4 _Gradation2;
			uniform float _EmissiveBoost;
			uniform float _MetaBoost;
			uniform float _Contrast;

            float4 frag_meta2(v2f_meta i) : SV_Target
            {
                FragmentCommonData data =UNITY_SETUP_BRDF_INPUT(i.uv);
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT(UnityMetaInput,o);
                fixed4 c = 0;
                o.Albedo = c.rgb;

				float cos21 = cos( ( _Rotate * UNITY_PI ) );
				float sin21 = sin( ( _Rotate * UNITY_PI ) );
				float2 rotator21 = mul( i.uv - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
				float temp_output_3_0 = pow( rotator21.y , _UVPower );
				float temp_output_5_0 = pow( ( 1.0 - rotator21.y ) , _UVPower );
				float smoothstepResult15 = smoothstep( 0.0 , 1.0 , saturate( ( temp_output_3_0 + temp_output_5_0 ) ));
				float4 lerpResult16 = lerp( float4(1,1,1,0) , float4( 0.15,0.15,0.15,0 ) , smoothstepResult15);

				float3 col = ( saturate( ( lerpResult16 + ( ( _Gradation1 * temp_output_3_0 ) + ( temp_output_5_0 * _Gradation2 ) ) ) ) * _EmissiveBoost ).rgb;
				col = pow(col,_Contrast);
                o.Emission = col * _MetaBoost;
                return UnityMetaFragment(o);
            }

            #pragma vertex vert_meta
            #pragma fragment frag_meta2

            ENDCG
        }
 
		Pass {
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fwdbase
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"

				uniform float _Rotate;
				uniform float _UVPower;
				uniform float4 _Gradation1;
				uniform float4 _Gradation2;
				uniform float _EmissiveBoost;
				uniform float _Contrast;
				
				struct v2f
				{
					float4	pos			: SV_POSITION;
					float2	uv			: TEXCOORD0;
					LIGHTING_COORDS(1,2)
				};
 
				float4 _MainTex_ST;
 
				v2f vert (appdata_tan v)
				{
					v2f o;
					
					o.pos = UnityObjectToClipPos( v.vertex);
					o.uv = TRANSFORM_TEX (v.texcoord, _MainTex).xy;
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					return o;
				}
 
				sampler2D _MainTex;
 
				fixed4 frag(v2f i) : COLOR
				{
					fixed atten = LIGHT_ATTENUATION(i);	// Light attenuation + shadows.

					float cos21 = cos( ( _Rotate * UNITY_PI ) );
					float sin21 = sin( ( _Rotate * UNITY_PI ) );
					float2 rotator21 = mul( i.uv - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
					float temp_output_3_0 = pow( rotator21.y , _UVPower );
					float temp_output_5_0 = pow( ( 1.0 - rotator21.y ) , _UVPower );
					float smoothstepResult15 = smoothstep( 0.0 , 1.0 , saturate( ( temp_output_3_0 + temp_output_5_0 ) ));
					float4 lerpResult16 = lerp( float4(1,1,1,0) , float4( 0.15,0.15,0.15,0 ) , smoothstepResult15);

					float3 col = ( saturate( ( lerpResult16 + ( ( _Gradation1 * temp_output_3_0 ) + ( temp_output_5_0 * _Gradation2 ) ) ) ) * _EmissiveBoost ).rgb;
					col = pow(col,_Contrast);

					return float4(col,1.0) * atten;
				}
			ENDCG
		}

		Pass
		{
			Name "ShadowCaster"
			Tags { "LightMode" = "ShadowCaster" }

			ZWrite On ZTest LEqual Cull Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct v2f {
				V2F_SHADOW_CASTER;
				UNITY_VERTEX_OUTPUT_STEREO
			};

			v2f vert( appdata_base v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag( v2f i ) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
	}

	CustomEditor "MetaFixGUI"
}