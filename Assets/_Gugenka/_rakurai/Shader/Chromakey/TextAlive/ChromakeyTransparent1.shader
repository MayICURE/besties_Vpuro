Shader "Custom/Chromakey/ChromakeyMultiSampling1"
{
    Properties
    {
	    [Header(Debug)]
		[Toggle]_Debug("Visualization Alpha",float) = 0.0
		[Toggle]_Hide("UseHide",int) = 0
	    [Header(Common)]
		[KeywordEnum(OFF, ALL_AXIS, Y_AXIS)] _BILLBOARD("Billboard Mode", Float) = 0
	    [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 0
		[Toggle]_IsUnlit("Unlit",float) = 0.0
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Metallic("Metallic",Range(0.0,1.0)) = 0.0
		_Glossiness("Smoothness",Range(0.0,1.0)) = 0.0
		[Header(ChromaKey)]
        _KeyColor("KeyColor", Color) = (0,1,0,0)
        _ColorCutoff("Cutoff", Range(0, 1)) = 0.2
        _ColorFeathering("ColorFeathering", Range(0, 1)) = 0.3
        _MaskFeathering("MaskFeathering", Range(0, 1)) = 1
        _Sharpening("Sharpening", Range(0, 1)) = 0.5
		[Header(Despill)]
		[KeywordEnum(RED, GREEN, BLUE)]_DespillKey("Despill KeyColor", Float) = 1
        _Despill("DespillStrength", Range(0, 1)) = 1
        _DespillLuminanceAdd("DespillLuminance", Range(0, 1)) = 0.2
		[Header(FadeClip)]
		[Toggle]_UseFadeClip("UseFadeClip", Float) = 0
		_FadeClipXDirStepMin("FadeClip XDirStepMin", Range( 0 , 1)) = 0.5
		_FadeClipXDirStepMax("FadeClip XDirStepMax", Range( 0 , 1)) = 0.6
		_FadeClipYDirStepMin("FadeClip YDirStepMin", Range( 0 , 1)) = 0.5
		_FadeClipYDirStepMax("FadeClip YDirStepMax", Range( 0 , 1)) = 0.6

		_Intensity("Intensity", Range(0, 9)) = 0
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
			#pragma multi_compile _DESPILLKEY_RED _DESPILLKEY_GREEN _DESPILLKEY_BLUE

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
			float4 _MainTex_TexelSize;
			float4 _KeyColor;
			float _ColorCutoff;
			float _ColorFeathering;
			float _MaskFeathering;
			float _Sharpening;
			float _Despill;
			float _DespillLuminanceAdd;

			float _Metallic;
			float _Glossiness;

			float _IsUnlit;

			float _ts,_Debug;
			int _Hide;

			uniform float _FadeClipXDirStepMin;
			uniform float _FadeClipXDirStepMax;
			uniform float _FadeClipYDirStepMin;
			uniform float _FadeClipYDirStepMax;
			uniform float _UseFadeClip;

			float _Intensity;

			float rgb2y(float3 c) 
			{
				return (0.299*c.r + 0.587*c.g + 0.114*c.b);
			}

			float rgb2cb(float3 c) 
			{
				return (0.5 + -0.168736*c.r - 0.331264*c.g + 0.5*c.b);
			}

			float rgb2cr(float3 c) 
			{
				return (0.5 + 0.5*c.r - 0.418688*c.g - 0.081312*c.b);
			}

		
			float colorclose(float Cb_p, float Cr_p, float Cb_key, float Cr_key, float tola, float tolb)
			{
				float temp = (Cb_key-Cb_p)*(Cb_key-Cb_p)+(Cr_key-Cr_p)*(Cr_key-Cr_p);
				float tola2 = tola*tola;
				float tolb2 = tolb*tolb;
				if (temp < tola2) return (0);
				if (temp < tolb2) return (temp-tola2)/(tolb2-tola2);
				return (1);
			}

			float maskedTex2D(sampler2D tex, float2 uv)
			{
				float4 color = tex2D(tex, uv);
                
				// Chroma key to CYK conversion
				float key_cb = rgb2cb(_KeyColor.rgb);
				float key_cr = rgb2cr(_KeyColor.rgb);
				float pix_cb = rgb2cb(color.rgb);
				float pix_cr = rgb2cr(color.rgb);

				return colorclose(pix_cb, pix_cr, key_cb, key_cr, _ColorCutoff, _ColorFeathering);
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
		

			void surf (Input i, inout SurfaceOutputStandard o)
			{
				float2 uv = i.uv_MainTex;

				float4 color = tex2D(_MainTex, uv);

				float2 pixelWidth = float2(1.0 / _MainTex_TexelSize.z, 0);
				float2 pixelHeight = float2(0, 1.0 / _MainTex_TexelSize.w);

				// Unfeathered mask
				float mask = maskedTex2D(_MainTex, uv);
				float c = mask;
				float r = maskedTex2D(_MainTex, uv + pixelWidth);
				float l = maskedTex2D(_MainTex, uv - pixelWidth);
				float d = maskedTex2D(_MainTex, uv + pixelHeight); 
				float u = maskedTex2D(_MainTex, uv - pixelHeight);

				float blurContribution = (r + l + d + u) * 0.25;

				float smoothedMask = smoothstep(_Sharpening, 1, lerp(c, blurContribution, _MaskFeathering));

				//
				color += color * _Intensity;

				float4 result = color * smoothedMask;

				//despill algorithm by https://benmcewan.com/blog/2018/05/20/understanding-despill-algorithms/
				float v;
				//v = (2*result.b+result.r)/4; //DOUBLE BLUE AVERAGE

				#if _DESPILLKEY_RED
				{
				   v = (result.g + result.b)/2;
				   if(result.r > v) result.r = lerp(result.r, v, _Despill);
				}
				#elif _DESPILLKEY_GREEN
				{                   
				   v = (result.r + result.b)/2;
				   if(result.g > v) result.g = lerp(result.g, v, _Despill);
				}
				#elif _DESPILLKEY_BLUE
				{
				   v = (result.r + result.g)/2;
				   if(result.b > v) result.b = lerp(result.b, v, _Despill);
				}
				#endif

				float4 dif = (color - result);
				float desaturatedDif = rgb2y(dif.xyz);
				result += lerp(0, desaturatedDif, _DespillLuminanceAdd);

				result.rgb = lerp(result.rgb,(smoothedMask).xxx,_Debug);

				float smoothstepResult8 = smoothstep( _FadeClipXDirStepMin , _FadeClipXDirStepMax , ( 1.0 - distance( uv.x , 0.5 ) ));
				float smoothstepResult13 = smoothstep( _FadeClipYDirStepMin , _FadeClipYDirStepMax , ( 1.0 - distance( uv.y , 0.5 ) ));

				//
				smoothstepResult13 = smoothstepResult13 * (1 - step( uv.y , 0.5 )) + step( uv.y , 0.5 );
				
				float lerpResult19 = lerp( 1.0 , ( smoothstepResult8 * smoothstepResult13 ) , _UseFadeClip);

				smoothedMask *= lerpResult19;

				o.Albedo = lerp(result.rgb * _Color.rgb,float3(0,0,0),_IsUnlit);
				o.Emission = lerp(float3(0,0,0),result.rgb * _Color.rgb,_IsUnlit);
				o.Metallic = lerp(_Metallic, 0.0, _IsUnlit);
				o.Smoothness = lerp(_Glossiness, 0.0, _IsUnlit);
				o.Alpha = lerp(lerp(smoothedMask,1.0,_Debug),0.0,_Hide);
				//float al = lerp(lerp(smoothedMask,1.0,_Debug),0.0,_Hide);
				//o.Alpha = al * (1 - step( uv.y , 0.5 )) + step( uv.y , 0.5 );
				/*
				o.Albedo = (lerp(c, r, _Despill)).rrr;
				o.Alpha = smoothedMask;
				*/
			
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
				

					half alphaRef = tex3D(_DitherMaskLOD, float3(vpos.xy * 0.25, o.Alpha * 0.9375)).a;
					clip(alphaRef - 0.01);
					SHADOW_CASTER_FRAGMENT(IN)
				}
				ENDCG
			}
		}
    FallBack "Diffuse"
}
