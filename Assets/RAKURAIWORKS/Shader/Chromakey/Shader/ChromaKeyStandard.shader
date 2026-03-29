Shader "Custom/Chromakey/ChromaKeyStandard"
{
	Properties
	{
		[Header(Debug)]
		[Toggle]_Debug("Visualization Alpha",float) = 0.0
		_AdjustAlphaMin("AdjustAlphaMin",Range(0.0,1.0)) = 0.0
		_AdjustAlphaMax("AdjustAlphaMax",Range(0.0,1.0)) = 1.0
		[Toggle]_Hide("UseHide",int) = 0
		[Toggle]_IsAVPro("ISAVPro",int) = 0
		[Header(Common)]
		[KeywordEnum(OFF, ALL_AXIS, Y_AXIS)] _BILLBOARD("Billboard Mode", Float) = 0
	    [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 0
	    [Toggle]_IsUnlit("Unlit",float) = 0.0
		_MainTex("MainTex",2D) = "White" {}
		_Color("Color",Color) = (1.0,1.0,1.0,1.0)
		_Metallic("Metallic",Range(0.0,1.0)) = 0.0
		_Glossiness("Smoothness",Range(0.0,1.0)) = 0.0
		[Header(ChromaKey)]
		_KeyColor("ChromaKeyColor",Color) = (0.0,0.0,0.0,1.0)
		_ChromaKeyHueRange("Hue Range", Range(0, 1)) = 0.15
		_ChromaKeySaturationRange("Saturation Range", Range(0, 1)) = 0.3
		_ChromaKeyBrightnessRange("Brightness Range", Range(0, 1)) = 0.3
		[Header(AngleTransition)]
		[KeywordEnum(Grain, Spike)] _Type("Type", Float) = 0
		_GrainStrength("GrainStrength", Float) = 50
		_LerpTime("LerpTime",float) = 0
		_LerpTimeScale("LerpTimeScale",float) = 1


	}

		SubShader
		{
			Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0"}

			Cull [_Cull]
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off


			CGINCLUDE
			#include "UnityStandardUtils.cginc"
			#include "UnityCG.cginc"
			#include "UnityPBSLighting.cginc"
			#include "Lighting.cginc"
			#pragma target 3.0

			#pragma multi_compile _BILLBOARD_OFF _BILLBOARD_ALL_AXIS _BILLBOARD_Y_AXIS
			#pragma multi_compile _TYPE_GRAIN _TYPE_SPIKE


			#define linearstep(edge0, edge1, x) min(max((x - edge0) / (edge1 - edge0), 0.0), 1.0)

			#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
			#else
			#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
			#endif
			#ifdef UNITY_PASS_SHADOWCASTER
				#undef INTERNAL_DATA
				#undef WorldReflectionVector
				#undef WorldNormalVector
				#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
				#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
				#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
			#endif

			struct Input
			{
				float2 uv_MainTex;
				float3 viewDir;
				INTERNAL_DATA
				float4 screenPos;
				float3 worldPos;
				float3 worldNormal;
			};

			sampler2D _MainTex;
			float4 _Color;
			float _Metallic;
			float _Glossiness;
			float _IsUnlit,_Debug;
			float _AdjustAlphaMin, _AdjustAlphaMax;

			float4 _KeyColor;

			float _ChromaKeyHueRange;
			float _ChromaKeySaturationRange;
			float _ChromaKeyBrightnessRange;

			int _Hide,_IsAVPro;

			uniform float _GrainStrength;
			uniform float _LerpTime,_LerpTimeScale;

			float3 hsv2rgb(float3 c)
			{
				float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
				float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
				return c.z * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
			}
			float3 rgb2hsv(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));
				float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));

				float d = q.x - min(q.w, q.y);
				float e = 1.0e-10;
				return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			inline float3 keyDiffrence(float3 col) {
				float3 hsv = rgb2hsv(col.rgb);
				float3 keyColor = rgb2hsv(_KeyColor.rgb);
				return abs(hsv - keyColor);
			}

			float GetAlpha(float3 col){
				float3 d = keyDiffrence(col);
				float alpha = saturate(length(d / float3(_ChromaKeyHueRange, _ChromaKeySaturationRange, _ChromaKeyBrightnessRange)) - 1.0);
				return alpha;
			}

			void Vert( inout appdata_full v, out Input o )
			{
			    UNITY_INITIALIZE_OUTPUT( Input, o );

			    #if _BILLBOARD_OFF
                {
                    
                }
                #elif _BILLBOARD_ALL_AXIS
                {                   
                    float3 upCamVec = normalize ( UNITY_MATRIX_V._m10_m11_m12 );
					float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
					float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
					float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
					v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;

					v.vertex = mul( v.vertex , unity_ObjectToWorld );
					v.vertex = mul( v.vertex , rotationCamMatrix );
					v.vertex = mul( v.vertex , unity_WorldToObject );
					v.vertex.xyz += 0;
					v.vertex.w = 1;
                }
                #elif _BILLBOARD_Y_AXIS
                {
					float3 upCamVec = float3( 0, 1, 0 );
					float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
					float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
					float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
					v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;

					v.vertex = mul( v.vertex , unity_ObjectToWorld );
					v.vertex = mul( v.vertex , rotationCamMatrix );
					v.vertex = mul( v.vertex , unity_WorldToObject );
					v.vertex.xyz += 0;
					v.vertex.w = 1;
                }
                #endif
				
			}

			void surf(Input i , inout SurfaceOutputStandard o)
			{
			    //Grain
			    float GrainUV218 = ( (_Time.y * 10.0) * ( ( 4.0 + i.uv_MainTex.x ) * ( i.uv_MainTex.y + 4.0 ) ) );
				float Strength = lerp(0.0,_GrainStrength,_LerpTime * _LerpTimeScale);
				float Grain = ( ( fmod( ( ( fmod( GrainUV218 , 13.0 ) + 1.0 ) * ( fmod( GrainUV218 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 ) * Strength );

				//PulseUV
				float2 temp_cast_0 = (( floor( ( i.uv_MainTex.y * 500.0 ) ) + _Time.y )).xx;
				float dotResult4_g1 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
				float lerpResult10_g1 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
				float2 appendResult13 = (float2(( ( i.uv_MainTex.x + sin( ( ( i.uv_MainTex.y * 30.0 ) * (_LerpTime * _LerpTimeScale) ) ) ) + ( ( lerpResult10_g1 * 0.4 ) * (_LerpTime * _LerpTimeScale) ) ) , i.uv_MainTex.y));
				float2 PulseUV = fmod(appendResult13,float2(1,1));
				PulseUV.x += Grain;
				PulseUV.x = 1.0 - PulseUV.x;


				float4 c;
				float alpha;
				#if _TYPE_GRAIN
				{
				    c = tex2D(_MainTex, float2(i.uv_MainTex.x + Grain,i.uv_MainTex.y)) * _Color;
					alpha = GetAlpha( tex2D(_MainTex, float2(i.uv_MainTex.x + Grain,i.uv_MainTex.y)).rgb);
					alpha = linearstep(_AdjustAlphaMin, _AdjustAlphaMax, alpha);
				}
				#elif _TYPE_SPIKE
				{
					c = tex2D(_MainTex, PulseUV) * _Color;
					alpha = GetAlpha( tex2D(_MainTex, PulseUV).rgb);
					alpha = linearstep(_AdjustAlphaMin, _AdjustAlphaMax, alpha);
				}
				#endif

				c.rgb = lerp(c.rgb,float3(alpha, alpha, alpha),_Debug);

				alpha = lerp(alpha,0.0,_Hide);

				o.Albedo = lerp(c.rgb, float3(0.0, 0.0, 0.0), _IsUnlit);
				o.Emission = lerp(float3(0.0, 0.0, 0.0), c.rgb, _IsUnlit);
				o.Metallic = lerp(_Metallic, 0.0, _IsUnlit);
				o.Smoothness = lerp(_Glossiness, 0.0, _IsUnlit);
				o.Alpha = lerp(alpha,1.0,_Debug);
			}

			ENDCG
			CGPROGRAM
			#pragma surface surf Standard alpha:blend fullforwardshadows exclude_path:deferred vertex:Vert

			ENDCG

			//CustomShadowCaster
			Pass
			{
				Name "ShadowCaster"
				Tags{ "LightMode" = "ShadowCaster" }
				ZWrite On
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 4.6
				#pragma multi_compile_shadowcaster
				#pragma multi_compile UNITY_PASS_SHADOWCASTER
				#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
				#include "HLSLSupport.cginc"
				#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
					#define CAN_SKIP_VPOS
				#endif
				#include "UnityCG.cginc"
				#include "Lighting.cginc"
				#include "UnityPBSLighting.cginc"
				sampler3D _DitherMaskLOD;
				struct v2f
				{
					V2F_SHADOW_CASTER;
					float2 customPack1 : TEXCOORD1;
					float4 screenPos : TEXCOORD2;
					float4 tSpace0 : TEXCOORD3;
					float4 tSpace1 : TEXCOORD4;
					float4 tSpace2 : TEXCOORD5;
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
				};
				v2f vert(appdata_full v)
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_OUTPUT(v2f, o);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					Input customInputData;
					float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
					half3 worldNormal = UnityObjectToWorldNormal(v.normal);
					half3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
					half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
					half3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
					o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
					o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
					o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
					o.customPack1.xy = customInputData.uv_MainTex;
					o.customPack1.xy = v.texcoord;
					TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
					o.screenPos = ComputeScreenPos(o.pos);
					return o;
				}
				half4 frag(v2f IN
				#if !defined( CAN_SKIP_VPOS )
				, UNITY_VPOS_TYPE vpos : VPOS
				#endif
				) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID(IN);
					Input surfIN;
					UNITY_INITIALIZE_OUTPUT(Input, surfIN);
					surfIN.uv_MainTex = IN.customPack1.xy;
					float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
					half3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
					surfIN.viewDir = IN.tSpace0.xyz * worldViewDir.x + IN.tSpace1.xyz * worldViewDir.y + IN.tSpace2.xyz * worldViewDir.z;
					surfIN.worldPos = worldPos;
					surfIN.worldNormal = float3(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z);
					surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
					surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
					surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
					surfIN.screenPos = IN.screenPos;
					SurfaceOutputStandard o;
					UNITY_INITIALIZE_OUTPUT(SurfaceOutputStandard, o)
					surf(surfIN, o);
					#if defined( CAN_SKIP_VPOS )
					float2 vpos = IN.pos;
					#endif


					float GrainUV218 = ( (_Time.y * 10.0) * ( ( 4.0 + IN.customPack1.x ) * ( IN.customPack1.y + 4.0 ) ) );
				    float Strength = lerp(0.0,_GrainStrength,_LerpTime * _LerpTimeScale);
				    float Grain = ( ( fmod( ( ( fmod( GrainUV218 , 13.0 ) + 1.0 ) * ( fmod( GrainUV218 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 ) * Strength );

					//PulseUV
					float2 temp_cast_0 = (( floor( ( IN.customPack1.y * 500.0 ) ) + _Time.y )).xx;
					float dotResult4_g1 = dot( temp_cast_0 , float2( 12.9898,78.233 ) );
					float lerpResult10_g1 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g1 ) * 43758.55 ) ));
					float2 appendResult13 = (float2(( ( IN.customPack1.x + sin( ( ( IN.customPack1.y * 30.0 ) * (_LerpTime * _LerpTimeScale) ) ) ) + ( ( lerpResult10_g1 * 0.4 ) * (_LerpTime * _LerpTimeScale) ) ) , IN.customPack1.y));
					float2 PulseUV = fmod(appendResult13,float2(1,1));
					PulseUV.x += Grain;
					PulseUV.x = 1.0 - PulseUV.x;

					float alpha;
					#if _TYPE_GRAIN
					{
						alpha = GetAlpha(tex2D(_MainTex,float2(IN.customPack1.x + Grain,1.0 - IN.customPack1.y)).rgb);
					}
					#elif _TYPE_SPIKE
					{
						alpha = GetAlpha(tex2D(_MainTex,float2(PulseUV.x,1.0 - PulseUV.y)).rgb);
					}
					#endif

					alpha = linearstep(_AdjustAlphaMin, _AdjustAlphaMax, alpha);
					alpha = lerp(alpha,0.0,_Hide);
				

					half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy * 0.25, lerp(o.Alpha,alpha,_IsAVPro) * 0.9375)).a;
					clip(alphaRef - 0.01);
					SHADOW_CASTER_FRAGMENT(IN)
				}
				ENDCG
			}
		}

}