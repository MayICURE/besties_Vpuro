Shader "Sanrio/Quest/BillBoardFix"
{
    Properties
    {
	   [Header(RenderSettings)]
	   [Enum(UnityEngine.Rendering.CullMode)]_Cull("Cull", Float) = 0
	   [KeywordEnum(OFF, ALL_AXIS, Y_AXIS)] _BILLBOARD("Billboard Mode", Float) = 0
	   _FixScale("FixScale",Vector) = (1,1,1,0)
	   [Header(Common)]
	   [Enum(Red,0,Alpha,1)]_Alpha("AlphaSource", int) = 1
       [NoScaleOffset]_MainTex ("Texture", 2D) = "white" {}
	   _Color("Color",Color) = (1,1,1,1)
	   _Intensity("Intensity",float) = 1.0
	   [Toggle] _Apply_ColorLerp("Use ColorLerp", Float) = 0
	   _InnerColor("InnerColor", Color) = (1,1,1,0)
	   _OuterColor("OuterColor", Color) = (1,1,1,0)
	   _ColorLerpMin("ColorLerpMin", Range( 0 , 1)) = 0
	   _ColorLerpMax("ColorLerpMax", Range( 0 , 1)) = 1
	   [Header(DepthFade)]
	   _FadeDistance("FadeDistance",float) = 0.0
	   [Header(AnimateIntensity)]
	   [Toggle] _Apply_Intensity("Use AnimateIntensity", Float) = 0
	   [NoScaleOffset]_NoiseTexture("NoiseTexture", 2D) = "white" {}
	   _IntensityMin("IntensityMin", float) = 0
	   _IntensityMax("IntensityMax", float) = 1
	   _AnimateOffset("AnimateOffset", Range( 0 , 1)) = 0
	   _AnimateSpeed("AnimateSpeed", Float) = 0
	   [Header(UV Coordinates)]
	   _TilingAndOffset("Tiling And Offset", Vector) = (1,1,0,0)
	   _ScrollSpeed("ScrollSpeed", Float) = 0
	   [Header(FlipBook)]
	   [Toggle] _Apply_FlipBook("Use FlipBookAnimation", Float) = 0
	   _Columns("Columns", int) = 0
	   _Rows("Rows", int) = 0
	   _FlipbookSpeed("Flipbook Speed", Float) = 0
	   _FlipbookOffset("Flipbook Offset", Float) = 0
    }
    SubShader
    {
        Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "DisableBatching" = "True"}

		Cull [_Cull]
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend OneMinusDstColor One
		ZWrite Off

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

			#pragma multi_compile_instancing

			#pragma shader_feature _APPLY_FLIPBOOK_ON
			#pragma shader_feature _APPLY_COLORLERP_ON
			#pragma shader_feature _APPLY_INTENSITY_ON
			#pragma shader_feature _BILLBOARD_OFF _BILLBOARD_ALL_AXIS _BILLBOARD_Y_AXIS

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
				float4 screenPos : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			uniform float4 _TilingAndOffset;
		    uniform float _ScrollSpeed;

			uniform int _Columns;
			uniform int _Rows;
			uniform float _FlipbookSpeed;
			uniform float _FlipbookOffset;

			uniform int _Alpha;

			uniform float _Intensity;

			uniform float _ColorLerpMin,_ColorLerpMax;

			uniform sampler2D _NoiseTexture;
			uniform float _IntensityMin;

			//uniform float _IntensityMax;
			//uniform float _AnimateSpeed;
			//uniform float _AnimateOffset;

			uniform float4 _FixScale;
			uniform float _FadeDistance;

			UNITY_INSTANCING_BUFFER_START(Props)
            UNITY_DEFINE_INSTANCED_PROP(float4, _Color)
			UNITY_DEFINE_INSTANCED_PROP(float4, _InnerColor)
			UNITY_DEFINE_INSTANCED_PROP(float4, _OuterColor)
			UNITY_DEFINE_INSTANCED_PROP(float,_IntensityMax)
			UNITY_DEFINE_INSTANCED_PROP(float,_AnimateSpeed)
			UNITY_DEFINE_INSTANCED_PROP(float,_AnimateOffset)
            UNITY_INSTANCING_BUFFER_END(Props)

			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		    uniform float4 _CameraDepthTexture_TexelSize;

			float linearstep(float a, float b, float x)
			{
				return saturate((x - a) / (b - a));
			}
 
            v2f vert (appdata v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				#if _BILLBOARD_OFF
                {
                    o.vertex = UnityObjectToClipPos(v.vertex);
                }
				#elif _BILLBOARD_ALL_AXIS
                {                   
					float3 scale = float3(length(mul(unity_ObjectToWorld, float4(1, 0, 0, 0)).xyz), length(mul(unity_ObjectToWorld, float4(0, 1, 0, 0)).xyz), length(mul(unity_ObjectToWorld, float4(0, 0, 1, 0)).xyz));
					scale *= _FixScale.rgb;
					float4 objPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));

					#if defined(USING_STEREO_MATRICES)
						float3 cameraPos = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * .5;
					#else
						float3 cameraPos = _WorldSpaceCameraPos;
					#endif

					float3 direction = normalize(cameraPos - objPos.xyz);

					float4x4 billboardMatrix = 0;
					billboardMatrix._m02 = direction.x;
					billboardMatrix._m12 = direction.y;
					billboardMatrix._m22 = direction.z;
					float3 xAxis = normalize(float3(-direction.z, 0, direction.x));
					billboardMatrix._m00 = xAxis.x;
					billboardMatrix._m10 = 0;
					billboardMatrix._m20 = xAxis.z;
					float3 yAxis = normalize(cross(xAxis, direction));
					billboardMatrix._m01 = yAxis.x;
					billboardMatrix._m11 = yAxis.y;
					billboardMatrix._m21 = yAxis.z;
				
					o.vertex = mul(UNITY_MATRIX_VP, mul(billboardMatrix, v.vertex * float4(scale, 0)) + objPos);
				}
				#elif _BILLBOARD_Y_AXIS
                {
                    float3 scale = float3(length(mul(unity_ObjectToWorld, float4(1, 0, 0, 0)).xyz), length(mul(unity_ObjectToWorld, float4(0, 1, 0, 0)).xyz), length(mul(unity_ObjectToWorld, float4(0, 0, 1, 0)).xyz));
		            scale *= _FixScale.rgb;
					float4 objPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1));

					#if defined(USING_STEREO_MATRICES)
						float3 cameraPos = (unity_StereoWorldSpaceCameraPos[0] + unity_StereoWorldSpaceCameraPos[1]) * .5;
					#else
						float3 cameraPos = _WorldSpaceCameraPos;
					#endif

					float3 direction = normalize(cameraPos - objPos.xyz);
				    direction.y = 0;
				    direction = normalize(direction);

					float4x4 billboardMatrix = 0;
					billboardMatrix._m02 = direction.x;
					billboardMatrix._m12 = direction.y;
					billboardMatrix._m22 = direction.z;
					float3 xAxis = normalize(float3(-direction.z, 0, direction.x));
					billboardMatrix._m00 = xAxis.x;
					billboardMatrix._m10 = 0;
					billboardMatrix._m20 = xAxis.z;
					float3 yAxis = normalize(cross(xAxis, direction));
					billboardMatrix._m01 = yAxis.x;
					billboardMatrix._m11 = yAxis.y;
					billboardMatrix._m21 = yAxis.z;
				
					o.vertex = mul(UNITY_MATRIX_VP, mul(billboardMatrix, v.vertex * float4(scale, 0)) + objPos);
                }
                #endif

				o.screenPos = ComputeScreenPos(o.vertex);
		
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			    UNITY_SETUP_INSTANCE_ID(i);

			    float2 uv = ( i.uv * float2(_TilingAndOffset.x,_TilingAndOffset.y) ) + (float2(_TilingAndOffset.z,_TilingAndOffset.w) * _Time.y);

				#ifdef _APPLY_FLIPBOOK_ON // *** BEGIN Flipbook UV Animation vars ***
				float fbtotaltiles2 = _Columns * _Rows;
				float fbcolsoffset2 = 1.0f / _Columns;
				float fbrowsoffset2 = 1.0f / _Rows;
				float fbspeed2 = _Time.y * _FlipbookSpeed;
				float2 fbtiling2 = float2(fbcolsoffset2, fbrowsoffset2);
				float fbcurrenttileindex2 = round( fmod( fbspeed2 + _FlipbookOffset, fbtotaltiles2) );
				fbcurrenttileindex2 += ( fbcurrenttileindex2 < 0) ? fbtotaltiles2 : 0;
				float fblinearindextox2 = round ( fmod ( fbcurrenttileindex2, _Columns ) );
				float fboffsetx2 = fblinearindextox2 * fbcolsoffset2;
				float fblinearindextoy2 = round( fmod( ( fbcurrenttileindex2 - fblinearindextox2 ) / _Columns, _Rows ) );
				fblinearindextoy2 = (int)(_Rows-1) - fblinearindextoy2;
				float fboffsety2 = fblinearindextoy2 * fbrowsoffset2;
				float2 fboffset2 = float2(fboffsetx2, fboffsety2);
				uv = i.uv * fbtiling2 + fboffset2;
				#endif

                fixed4 tex = tex2D(_MainTex, uv);
				fixed3 col = UNITY_ACCESS_INSTANCED_PROP(Props, _Color).rgb;
				float alpha = lerp(tex.r,tex.a,_Alpha);

				fixed3 Color;
				#ifdef _APPLY_COLORLERP_ON
				float lerpValue = linearstep( _ColorLerpMin , _ColorLerpMax , alpha);
				fixed3 InnerColor_Instances = UNITY_ACCESS_INSTANCED_PROP(Props, _InnerColor).rgb;
				fixed3 OuterColor_Instances = UNITY_ACCESS_INSTANCED_PROP(Props, _OuterColor).rgb;
				Color = lerp(OuterColor_Instances, InnerColor_Instances, lerpValue);
				#else
				Color = col.rgb;
				#endif

				float Intensity = max(_Intensity,0.0);
				#ifdef _APPLY_INTENSITY_ON
				float IntensityMax_Instances = UNITY_ACCESS_INSTANCED_PROP(Props,_IntensityMax);
				float AnimateSpeed_Instances = UNITY_ACCESS_INSTANCED_PROP(Props,_AnimateSpeed);
				float AnimateOffset_Instances = UNITY_ACCESS_INSTANCED_PROP(Props,_AnimateOffset);

			    float2 NoiseUV = (float2(_Time.y * AnimateSpeed_Instances, AnimateOffset_Instances));
			    Intensity = ((_IntensityMin + (saturate(tex2D( _NoiseTexture, NoiseUV).r) - 0.0) * (IntensityMax_Instances - _IntensityMin) / (1.0 - 0.0)));
				#endif

				//DepthFade
				float4 screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
				float4 screenPosNorm = screenPos / screenPos.w;
				screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? screenPosNorm.z : screenPosNorm.z * 0.5 + 0.5;
				float screenDepth = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, screenPosNorm.xy ));
				float distanceDepth = abs( ( screenDepth - LinearEyeDepth( screenPosNorm.z ) ) / ( _FadeDistance ) );
				distanceDepth = saturate(distanceDepth);

				fixed4 finalColor = float4((tex.rgb * Color) * Intensity,1.0);
				finalColor *= distanceDepth;


                return saturate(finalColor);
            }
            ENDCG
        }
    }
}
