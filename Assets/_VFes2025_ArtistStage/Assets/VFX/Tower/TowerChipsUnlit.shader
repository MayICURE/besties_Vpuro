
Shader "VFes2025ArtistStage/TowerChipsUnlit"
{
	Properties
	{
		[HDR]_GlitchColor("GlitchColor", Color) = (0,0,0,0)
		[Header(Grain)]_GrainIntensity("Grain Intensity", Range( 0 , 1)) = 0
		_GrainStrength("Grain Strength", Float) = 100
		[Toggle]_InvertGrain("Invert Grain", Float) = 0
		[Header(Offset)]_VertexOffsetAxis("VertexOffset Axis", Vector) = (0,0,0,0)
		_VertexOffsetTime("VertexOffset Time", Float) = 0

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
			#define ASE_NEEDS_VERT_COLOR


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
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float3 _VertexOffsetAxis;
			uniform float _VertexOffsetTime;
			uniform float4 _GlitchColor;
			uniform float _GrainStrength;
			uniform float _InvertGrain;
			uniform float _GrainIntensity;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float mulTime22 = _Time.y * _VertexOffsetTime;
				float Rand19 = v.color.b;
				float lerpResult11 = lerp( 1.0 , -1.0 , step( v.color.r , 0.5 ));
				float RandX20 = lerpResult11;
				float mulTime33 = _Time.y * _VertexOffsetTime;
				float lerpResult18 = lerp( 1.0 , -1.0 , step( v.color.g , 0.5 ));
				float RandY21 = lerpResult18;
				float3 appendResult43 = (float3(( (sin( ( mulTime22 + ( Rand19 * 100.0 ) ) )*0.5 + 0.0) * RandX20 ) , ( (sin( ( mulTime33 + ( Rand19 * 150.0 ) ) )*0.5 + 0.0) * RandY21 ) , 0.0));
				
				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = ( _VertexOffsetAxis * appendResult43 );
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
				float mulTime117 = _Time.y * 0.5;
				float temp_output_118_0 = sin( ( mulTime117 + ( i.ase_color.r * 100.0 ) ) );
				float mulTime55 = _Time.y * 5.0;
				float4 temp_cast_0 = (mulTime55).xxxx;
				float div59=256.0/float(80);
				float4 posterize59 = ( floor( temp_cast_0 * div59 ) / div59 );
				float2 texCoord48 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV50 = texCoord48;
				float2 break56 = UV50;
				float GrainUV63 = ( (posterize59).r * ( ( 4.0 + break56.x ) * ( break56.y + 4.0 ) ) );
				float temp_output_88_0 = ( fmod( ( ( fmod( GrainUV63 , 13.0 ) + 1.0 ) * ( fmod( GrainUV63 , 123.0 ) + 1.0 ) ) , 0.01 ) - 0.005 );
				float temp_output_91_0 = ( temp_output_88_0 * _GrainStrength );
				float lerpResult97 = lerp( temp_output_91_0 , ( 1.0 - temp_output_91_0 ) , _InvertGrain);
				float lerpResult102 = lerp( 1.0 , lerpResult97 , _GrainIntensity);
				float Grain104 = lerpResult102;
				
				
				finalColor = ( ( _GlitchColor * (0.15 + ((temp_output_118_0*0.5 + 0.5) - 0.0) * (3.0 - 0.15) / (1.0 - 0.0)) ) * Grain104 );
				return finalColor;
			}
			ENDCG
		}
	}

	Fallback "Unlit/Color"
}