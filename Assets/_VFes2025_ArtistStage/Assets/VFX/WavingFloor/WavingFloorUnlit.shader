
Shader "VFes2025ArtistStage/WavingFloorUnlit"
{
	Properties
	{
		_GridTex("GridTex", 2D) = "white" {}
		_BaseColor("BaseColor", Color) = (0,0,0,0)
		_LineColor("LineColor", Color) = (1,1,1,0)
		_GridTiling("Grid Tiling", Vector) = (10,10,0,0)
		[NoScaleOffset]_VertexOffsetNoiseTex("VertexOffset NoiseTex", 2D) = "white" {}
		_VertexOffset("VertexOffset", Float) = 0
		_VertexOffsetMinPos("VertexOffset MinPos", Float) = 0
		_VertexOffsetMaxPos("VertexOffset MaxPos", Float) = 1
		_VertexOffsetBaseScale("VertexOffset BaseScale", Float) = 1
		_VertexOffsetScale("VertexOffset Scale", Vector) = (1,1,0,0)
		_VertexOffsetBaseScroll("VertexOffset BaseScroll", Float) = 0
		_VertexOffsetScroll("VertexOffset Scroll", Vector) = (0,0,0,0)
		_DistanceMaskStart("DistanceMask Start", Float) = 30
		_DistanceMaskEnd("DistanceMask End", Float) = 60
		_Emissive("Emissive", Float) = 1
		_EmissiveColor("EmissiveColor", Color) = (0,0,0,0)
		_EmissiveStepMin("Emissive StepMin", Range( 0 , 1)) = 0
		_EmissiveStepMax("Emissive StepMax", Range( 0 , 1)) = 1
		[Toggle]_UseFog("UseFog", Float) = 0
		_FogColor("FogColor", Color) = (0,0,0,0)
		_FogStartPos("FogStartPos", Float) = 50
		_FogEndPos("FogEndPos", Float) = 100

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" "DisableBatching" = "True"}
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
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _VertexOffsetNoiseTex;
			uniform float2 _VertexOffsetScale;
			uniform float _VertexOffsetBaseScale;
			uniform float2 _VertexOffsetScroll;
			uniform float _VertexOffsetBaseScroll;
			uniform float _VertexOffsetMinPos;
			uniform float _VertexOffsetMaxPos;
			uniform float _VertexOffset;
			uniform float _DistanceMaskStart;
			uniform float _DistanceMaskEnd;
			uniform float4 _LineColor;
			uniform float4 _BaseColor;
			uniform sampler2D _GridTex;
			uniform float2 _GridTiling;
			uniform float _EmissiveStepMin;
			uniform float _EmissiveStepMax;
			uniform float4 _EmissiveColor;
			uniform float _Emissive;
			uniform float4 _FogColor;
			uniform float _FogStartPos;
			uniform float _FogEndPos;
			uniform float _UseFog;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, float4( (v.vertex).xyz, 1 )).xyz;
				float2 temp_output_32_0 = ( ( (ase_worldPos).xz * _VertexOffsetScale * _VertexOffsetBaseScale ) + ( _VertexOffsetScroll * _VertexOffsetBaseScroll * _Time.y ) );
				float4 tex2DNode178 = tex2Dlod( _VertexOffsetNoiseTex, float4( temp_output_32_0, 0, 0.0) );
				float smoothstepResult69 = smoothstep( 0.0 , 1.0 , tex2DNode178.a);
				float smoothstepResult182 = smoothstep( _DistanceMaskStart , _DistanceMaskEnd , distance( _WorldSpaceCameraPos , ase_worldPos ));
				
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( float3(0,1,0) * (_VertexOffsetMinPos + (smoothstepResult69 - 0.0) * (_VertexOffsetMaxPos - _VertexOffsetMinPos) / (1.0 - 0.0)) * _VertexOffset * ( 1.0 - smoothstepResult182 ) );
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
				float smoothstepResult110 = smoothstep( 0.0 , 1.0 , tex2D( _GridTex, ( (WorldPosition).xz * _GridTiling ) ).r);
				float Mask80 = smoothstepResult110;
				float4 lerpResult6 = lerp( _LineColor , float4( _BaseColor.rgb , 0.0 ) , Mask80);
				float2 temp_output_32_0 = ( ( (WorldPosition).xz * _VertexOffsetScale * _VertexOffsetBaseScale ) + ( _VertexOffsetScroll * _VertexOffsetBaseScroll * _Time.y ) );
				float4 tex2DNode178 = tex2D( _VertexOffsetNoiseTex, temp_output_32_0 );
				float Noise44 = tex2DNode178.a;
				float smoothstepResult54 = smoothstep( 0.0 , 1.0 , Noise44);
				float lerpResult47 = lerp( 0.1 , 1.0 , smoothstepResult54);
				float smoothstepResult113 = smoothstep( _EmissiveStepMin , _EmissiveStepMax , Noise44);
				float smoothstepResult165 = smoothstep( _FogStartPos , _FogEndPos , distance( WorldPosition , _WorldSpaceCameraPos ));
				float lerpResult171 = lerp( 0.0 , smoothstepResult165 , _UseFog);
				float4 lerpResult169 = lerp( ( ( lerpResult6 * lerpResult47 ) + ( smoothstepResult113 * _EmissiveColor * _Emissive * ( 1.0 - Mask80 ) ) ) , _FogColor , lerpResult171);
				
				
				finalColor = lerpResult169;
				return finalColor;
			}
			ENDCG
		}
	}
	
	Fallback "Unlit/Texture"
}