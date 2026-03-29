
Shader "VFes2025ArtistStage/PropsUnlit"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_Color("Color", Color) = (1,1,1,0)
		[Header(UVGlitch)]_MaskStepX("MaskStepX", Range( 0 , 1)) = 0.5
		_MaskStepY("MaskStepY", Range( 0 , 1)) = 0.5
		_UVGlitchIntensity("UVGlitch Intensity", Float) = 0.2
		_UVGlitchStep("UVGlitch Step", Range( 0 , 1)) = 1
		_UVGlitchThreshold("UVGlitch Threshold", Range( 0 , 1)) = 0.2
		_Tiling("Tiling", Float) = 20
		_TilingAxis("TilingAxis", Vector) = (1,1,0,0)
		_Scroll("Scroll", Vector) = (1,1,0,0)
		_JitterMin("JitterMin", Float) = 0.0005
		_JitterMax("JitterMax", Float) = 0.005
		[Toggle]_PosRandom("PosRandom", Float) = 0
		[Header(Line)]_LineNoiseIntensity("LineNoise Intensity", Range( 0 , 1)) = 0
		_LineNoiseBaseScale("LineNoise BaseScale", Float) = 1
		_LineNoiseScale("LineNoise Scale", Vector) = (1,1,0,0)
		_LineNoiseScroll("LineNoise Scroll", Vector) = (0,0,0,0)
		_LineNoiseStep("LineNoise Step", Range( 0 , 1)) = 0
		_LineNoiseWidth("LineNoise Width", Range( 0 , 1)) = 0
		_LineNoiseHeight("LineNoise Height", Range( 0 , 1)) = 1
		_LineNoiseOffset("LineNoise Offset", Float) = 1
		[Header(Scanline)]_ScanlineIntensity("Scanline Intensity", Range( 0 , 1)) = 0
		_ScanlineScale("Scanline Scale", Float) = 50
		_ScanlineScroll("Scanline Scroll", Float) = 0
		[Toggle]_ScanlineDistanceFade("Scanline DistanceFade", Float) = 0
		_ScanlineFadeStart("Scanline FadeStart", Float) = 3
		_ScanlineFadeEnd("Scanline FadeEnd", Float) = 1
		[Header(Grain)]_GrainIntensity("Grain Intensity", Range( 0 , 1)) = 0
		_GrainStrength("Grain Strength", Float) = 100
		[Toggle]_InvertGrain("Invert Grain", Float) = 0
		[Header(VertexOffset)]_VertexOffsetAxis("VertexOffset Axis", Vector) = (0,0,0,0)
		_VertexOffsetTime("VertexOffset Time", Float) = 0.5

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "DisableBatching"="True" }
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

			uniform float3 _VertexOffsetAxis;
			uniform float _VertexOffsetTime;
			uniform float2 _LineNoiseScale;
			uniform float _LineNoiseBaseScale;
			uniform float2 _LineNoiseScroll;
			uniform float _LineNoiseOffset;
			uniform float _LineNoiseWidth;
			uniform float _LineNoiseHeight;
			uniform float _LineNoiseStep;
			uniform float _LineNoiseIntensity;
			uniform sampler2D _MainTex;
			uniform float _JitterMin;
			uniform float _JitterMax;
			uniform float2 _TilingAxis;
			uniform float _Tiling;
			uniform float2 _Scroll;
			uniform float _UVGlitchStep;
			uniform float _MaskStepX;
			uniform float _MaskStepY;
			uniform float _PosRandom;
			uniform float _UVGlitchThreshold;
			uniform float _UVGlitchIntensity;
			uniform float4 _Color;
			uniform float _ScanlineScale;
			uniform float _ScanlineScroll;
			uniform float _ScanlineIntensity;
			uniform float _ScanlineFadeEnd;
			uniform float _ScanlineFadeStart;
			uniform float _ScanlineDistanceFade;
			uniform float _GrainStrength;
			uniform float _InvertGrain;
			uniform float _GrainIntensity;
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

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime385 = _Time.y * _VertexOffsetTime;
				float4 transform377 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float PosRandom383 = frac( ( sin( ( transform377.x + transform377.y + transform377.z ) ) * 437.276 ) );
				float temp_output_386_0 = sin( ( mulTime385 + ( PosRandom383 * 100.0 ) ) );
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( _VertexOffsetAxis * (temp_output_386_0*0.5 + 0.5) );
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
				float2 texCoord3 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV2 = texCoord3;
				float2 temp_output_291_0 = ( ( UV2 * _LineNoiseScale * _LineNoiseBaseScale ) + ( _LineNoiseScroll * fmod( _Time.y , 8600.0 ) ) );
				float2 temp_output_292_0 = floor( temp_output_291_0 );
				float dotResult4_g58 = dot( ( temp_output_292_0 + float2( 2,8 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g58 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g58 ) * 43758.55 ) ));
				float temp_output_294_0 = lerpResult10_g58;
				float smoothstepResult295 = smoothstep( 0.0 , 1.0 , temp_output_294_0);
				float2 appendResult299 = (float2(( (-1.0 + (smoothstepResult295 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * _LineNoiseOffset ) , 0.0));
				float2 LineNoise_Offset328 = appendResult299;
				float dotResult4_g88 = dot( ( temp_output_292_0 + float2( 9,3 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g88 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g88 ) * 43758.55 ) ));
				float temp_output_2_0_g94 = ( _LineNoiseWidth * (0.5 + (lerpResult10_g88 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
				float dotResult4_g89 = dot( ( temp_output_292_0 + float2( 17,5 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float temp_output_3_0_g94 = ( _LineNoiseHeight * (0.5 + (lerpResult10_g89 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) );
				float2 appendResult21_g94 = (float2(temp_output_2_0_g94 , temp_output_3_0_g94));
				float Radius25_g94 = max( min( min( abs( ( 0.01 * 2 ) ) , abs( temp_output_2_0_g94 ) ) , abs( temp_output_3_0_g94 ) ) , 1E-05 );
				float2 temp_cast_0 = (0.0).xx;
				float temp_output_30_0_g94 = ( length( max( ( ( abs( (( frac( temp_output_291_0 ) + LineNoise_Offset328 )*2.0 + -1.0) ) - appendResult21_g94 ) + Radius25_g94 ) , temp_cast_0 ) ) / Radius25_g94 );
				float mulTime1_g82 = _Time.y * 1.5;
				float lerpResult7_g82 = lerp( 128.0 , 1.0 , 0.75);
				float temp_output_2_0_g82 = ( 256.0 / lerpResult7_g82 );
				float temp_output_338_0 = ( floor( ( fmod( mulTime1_g82 , 6800.0 ) * temp_output_2_0_g82 ) ) / temp_output_2_0_g82 );
				float2 appendResult339 = (float2(temp_output_338_0 , 5.0));
				float dotResult4_g84 = dot( appendResult339 , float2( 12.9898,78.233 ) );
				float lerpResult10_g84 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g84 ) * 43758.55 ) ));
				float dotResult4_g93 = dot( ( temp_output_292_0 + ( lerpResult10_g84 * 218.0 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g93 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g93 ) * 43758.55 ) ));
				float temp_output_319_0 = ( saturate( ( ( 1.0 - temp_output_30_0_g94 ) / fwidth( temp_output_30_0_g94 ) ) ) * step( lerpResult10_g93 , _LineNoiseStep ) );
				float LineNoise322 = ( temp_output_319_0 * _LineNoiseIntensity );
				float LineNoise_NoiseValue333 = temp_output_294_0;
				float2 texCoord62 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV64 = texCoord62;
				float2 break360 = UV64;
				float dotResult4_g95 = dot( ( ( UV64 * float2( 0.001,1 ) ) + _Time.y ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g95 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g95 ) * 43758.55 ) ));
				float dotResult4_g80 = dot( ( floor( ( ( UV2 * _TilingAxis * _Tiling ) + ( _Time.y * _Scroll ) ) ) + float2( 12,47 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g80 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g80 ) * 43758.55 ) ));
				float mulTime33 = _Time.y * -0.5;
				float dotResult4_g81 = dot( ( floor( ( ( UV2 * _TilingAxis * _Tiling * 0.9 ) + ( mulTime33 * _Scroll ) ) ) + float2( 21,6 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g81 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g81 ) * 43758.55 ) ));
				float temp_output_39_0 = min( lerpResult10_g80 , lerpResult10_g81 );
				float temp_output_178_0 = ( temp_output_39_0 * step( temp_output_39_0 , _UVGlitchStep ) );
				float NoiseBase143 = temp_output_178_0;
				float temp_output_12_0_g85 = 0.0;
				float mulTime1_g83 = _Time.y * 3.0;
				float lerpResult7_g83 = lerp( 128.0 , 1.0 , 0.5);
				float temp_output_2_0_g83 = ( 256.0 / lerpResult7_g83 );
				float temp_output_10_0_g85 = ( floor( ( fmod( mulTime1_g83 , 6800.0 ) * temp_output_2_0_g83 ) ) / temp_output_2_0_g83 );
				float temp_output_2_0_g85 = floor( ( temp_output_10_0_g85 % 6800.0 ) );
				float2 appendResult8_g85 = (float2(temp_output_12_0_g85 , temp_output_2_0_g85));
				float dotResult4_g86 = dot( appendResult8_g85 , float2( 12.9898,78.233 ) );
				float lerpResult10_g86 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g86 ) * 43758.55 ) ));
				float2 appendResult7_g85 = (float2(temp_output_12_0_g85 , ( temp_output_2_0_g85 + 1.0 )));
				float dotResult4_g87 = dot( appendResult7_g85 , float2( 12.9898,78.233 ) );
				float lerpResult10_g87 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g87 ) * 43758.55 ) ));
				float smoothstepResult4_g85 = smoothstep( 0.0 , 1.0 , frac( fmod( temp_output_10_0_g85 , 6800.0 ) ));
				float lerpResult13_g85 = lerp( lerpResult10_g86 , lerpResult10_g87 , smoothstepResult4_g85);
				float temp_output_185_0 = lerpResult13_g85;
				float UVGlitch_Intensity199 = (0.25 + (temp_output_185_0 - 0.0) * (1.0 - 0.25) / (1.0 - 0.0));
				float2 break5 = abs( (UV2*2.0 + -1.0) );
				float smoothstepResult15 = smoothstep( _MaskStepX , 1.0 , break5.x);
				float temp_output_17_0 = ( 1.0 - smoothstepResult15 );
				float smoothstepResult16 = smoothstep( _MaskStepY , 1.0 , break5.y);
				float temp_output_18_0 = ( 1.0 - smoothstepResult16 );
				float MaskBase142 = step( min( temp_output_17_0 , temp_output_18_0 ) , temp_output_178_0 );
				float lerpResult252 = lerp( 0.0 , ( NoiseBase143 * UVGlitch_Intensity199 ) , MaskBase142);
				float temp_output_12_0_g90 = 13.0;
				float mulTime188 = _Time.y * 2.8;
				float4 transform377 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float PosRandom383 = frac( ( sin( ( transform377.x + transform377.y + transform377.z ) ) * 437.276 ) );
				float lerpResult401 = lerp( 0.0 , ( PosRandom383 * 50.0 ) , _PosRandom);
				float temp_output_10_0_g90 = ( mulTime188 + lerpResult401 );
				float temp_output_2_0_g90 = floor( ( temp_output_10_0_g90 % 6800.0 ) );
				float2 appendResult8_g90 = (float2(temp_output_12_0_g90 , temp_output_2_0_g90));
				float dotResult4_g91 = dot( appendResult8_g90 , float2( 12.9898,78.233 ) );
				float lerpResult10_g91 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g91 ) * 43758.55 ) ));
				float2 appendResult7_g90 = (float2(temp_output_12_0_g90 , ( temp_output_2_0_g90 + 1.0 )));
				float dotResult4_g92 = dot( appendResult7_g90 , float2( 12.9898,78.233 ) );
				float lerpResult10_g92 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g92 ) * 43758.55 ) ));
				float smoothstepResult4_g90 = smoothstep( 0.0 , 1.0 , frac( fmod( temp_output_10_0_g90 , 6800.0 ) ));
				float lerpResult13_g90 = lerp( lerpResult10_g91 , lerpResult10_g92 , smoothstepResult4_g90);
				float temp_output_187_0 = step( lerpResult13_g90 , _UVGlitchThreshold );
				float UVGlitch_StepMask198 = temp_output_187_0;
				float lerpResult253 = lerp( 0.0 , lerpResult252 , UVGlitch_StepMask198);
				float lerpResult254 = lerp( _JitterMin , _JitterMax , lerpResult253);
				float Jitter174 = ( (-1.0 + (lerpResult10_g95 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * lerpResult254 );
				float lerpResult191 = lerp( 0.0 , ( ( (-1.0 + (NoiseBase143 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * _UVGlitchIntensity * temp_output_185_0 ) * temp_output_187_0 ) , MaskBase142);
				float UVGlitch194 = lerpResult191;
				float2 appendResult137 = (float2(( break360.x + Jitter174 + UVGlitch194 + ( ( LineNoise322 * (-1.0 + (LineNoise_NoiseValue333 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) ) * 0.1 ) ) , break360.y));
				float3 hsvTorgb211 = RGBToHSV( tex2D( _MainTex, appendResult137 ).rgb );
				float lerpResult204 = lerp( 0.0 , ( (-0.5 + (NoiseBase143 - 0.0) * (1.0 - -0.5) / (1.0 - 0.0)) * UVGlitch_Intensity199 ) , MaskBase142);
				float lerpResult207 = lerp( 0.0 , lerpResult204 , UVGlitch_StepMask198);
				float3 hsvTorgb210 = HSVToRGB( float3(( ( ( LineNoise322 * LineNoise_NoiseValue333 ) * 0.2 ) + ( hsvTorgb211.x + ( lerpResult207 * 0.2 ) ) ),saturate( ( hsvTorgb211.y + ( lerpResult207 * 0.1 ) ) ),saturate( ( hsvTorgb211.z + ( lerpResult207 * 0.1 ) ) )) );
				float temp_output_106_0 = sin( ( ( ( UV2 + float2( 0,0 ) ).y * _ScanlineScale ) + fmod( ( _Time.y * _ScanlineScroll ) , 6800.0 ) ) );
				float4 transform364 = mul(unity_ObjectToWorld,float4( 0,0,0,1 ));
				float smoothstepResult367 = smoothstep( _ScanlineFadeEnd , _ScanlineFadeStart , distance( float4( _WorldSpaceCameraPos , 0.0 ) , transform364 ));
				float lerpResult373 = lerp( 1.0 , (0.1 + (( 1.0 - saturate( smoothstepResult367 ) ) - 0.0) * (1.0 - 0.1) / (1.0 - 0.0)) , _ScanlineDistanceFade);
				float lerpResult117 = lerp( 1.0 , pow( saturate( temp_output_106_0 ) , 3.0 ) , ( _ScanlineIntensity * lerpResult373 ));
				float Scanline119 = lerpResult117;
				float mulTime69 = _Time.y * 5.0;
				float4 temp_cast_3 = (mulTime69).xxxx;
				float div73=256.0/float(80);
				float4 posterize73 = ( floor( temp_cast_3 * div73 ) / div73 );
				float2 break70 = UV2;
				float GrainUV77 = ( (posterize73).r * ( ( 4.0 + break70.x ) * ( break70.y + 4.0 ) ) );
				float temp_output_102_0 = ( fmod( ( ( fmod( GrainUV77 , 13.0 ) + 1.0 ) * ( fmod( GrainUV77 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 );
				float temp_output_105_0 = ( temp_output_102_0 * _GrainStrength );
				float lerpResult111 = lerp( temp_output_105_0 , ( 1.0 - temp_output_105_0 ) , _InvertGrain);
				float lerpResult224 = lerp( 0.0 , ( NoiseBase143 * UVGlitch_Intensity199 ) , MaskBase142);
				float lerpResult225 = lerp( 0.0 , lerpResult224 , UVGlitch_StepMask198);
				float lerpResult116 = lerp( 1.0 , lerpResult111 , ( _GrainIntensity + ( lerpResult225 * 0.25 ) ));
				float Grain118 = lerpResult116;
				
				
				finalColor = ( ( float4( hsvTorgb210 , 0.0 ) * _Color ) * Scanline119 * Grain118 );
				return finalColor;
			}
			ENDCG
		}
	}

	Fallback "Unlit/Texture"
}