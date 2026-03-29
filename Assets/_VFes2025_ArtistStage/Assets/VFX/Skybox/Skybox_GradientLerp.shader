Shader "VFes2025ArtistStage/Skybox_GradientLerp"
{
    Properties
    {
        _GradientUnderColor("Gradient UnderColor", Color) = (0,0,0,0)
		_GradientTopColor("Gradient TopColor", Color) = (1,1,1,0)
		_GradientStepMin("Gradient StepMin", Range( 0 , 1)) = 0
		_GradientStepMax("Gradient StepMax", Range( 0 , 1)) = 1

        //Star
		[Header(Star)]
        _Intensity("Intensity", Float) = 1
		_UVBending("UV Bending", Range( 0 , 1)) = 0.8
		_Tiling("Tiling", Float) = 30
		_Scroll("Scroll", Vector) = (0,0,0,0)
		_HeightMaskMin("HeightMaskMin", Range( 0 , 1)) = 0
		_HeightMaskMax("HeightMaskMax", Range( 0 , 1)) = 1
		_Step("Step", Range( 0 , 1)) = 0
		_Animation("Animation", Float) = 0.5
    }
    SubShader
    {
        Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
        Cull Off ZWrite Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _GradientUnderColor;
		    float4 _GradientTopColor;
		    float _GradientStepMin;
		    float _GradientStepMax;

            uniform float _UVBending;
		    uniform float _Tiling;
		    uniform float2 _Scroll;
		    uniform float _Step;
		    uniform float _Animation;
		    uniform float _Intensity;
		    uniform float _HeightMaskMin;
		    uniform float _HeightMaskMax;

            struct appdata
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 texcoord : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float remap(float value, float inputMin, float inputMax, float outputMin, float outputMax)
            {
                return (value - inputMin) * ((outputMax - outputMin) / (inputMax - inputMin)) + outputMin;
            }

            float linearstep(float a, float b, float x)
            {
                return saturate((x - a) / (b - a));
            }

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}


            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.vertex.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 col = (1,1,1,1);
                float grad = saturate(i.texcoord.y);
                grad = linearstep(_GradientStepMin, _GradientStepMax, grad);

                col.rgb = lerp(_GradientUnderColor, _GradientTopColor, grad).rgb;

                //Star
                float3 ase_vertex3Pos = i.texcoord;
				float2 appendResult273 = (float2(ase_vertex3Pos.x , ase_vertex3Pos.z));
				float lerpResult274 = lerp( 1.0 , ase_vertex3Pos.y , _UVBending);
				float2 BaseUV276 = ( appendResult273 / lerpResult274 );
				float2 temp_output_404_0 = ( ( BaseUV276 * _Tiling ) + ( _Time.y * _Scroll ) );
				float2 FloorUV292 = floor( temp_output_404_0 );
				float dotResult4_g10 = dot( ( FloorUV292 + float2( 5,16 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g10 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g10 ) * 43758.55 ) ));
				float smoothstepResult387 = smoothstep( 0.0 , 1.0 , lerpResult10_g10);
				float lerpResult386 = lerp( 0.05 , 0.1 , smoothstepResult387);
				float2 temp_output_300_0 = frac( temp_output_404_0 );
				float2 temp_output_368_0 = (temp_output_300_0*2.0 + -1.0);
				float smoothstepResult381 = smoothstep( 0.0 , 1.0 , saturate( ( lerpResult386 / length( temp_output_368_0 ) ) ));
				float mulTime465 = _Time.y * 0.3;
				float dotResult4_g9 = dot( ( FloorUV292 + float2( 5,13 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g9 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g9 ) * 43758.55 ) ));
				float temp_output_332_0 = lerpResult10_g9;
				float smoothstepResult466 = smoothstep( 0.5 , 1.0 , frac( ( mulTime465 + temp_output_332_0 ) ));
				float RandRotate447 = ( ( smoothstepResult466 * 2.0 ) * UNITY_PI );
				float cos444 = cos( RandRotate447 );
				float sin444 = sin( RandRotate447 );
				float2 rotator444 = mul( temp_output_300_0 - float2( 0.5,0.5 ) , float2x2( cos444 , -sin444 , sin444 , cos444 )) + float2( 0.5,0.5 );
				float2 break433 = (rotator444*2.0 + -1.0);
				float dotResult4_g12 = dot( ( FloorUV292 + float2( 17,8 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g12 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g12 ) * 43758.55 ) ));
				float smoothstepResult474 = smoothstep( 0.15 , 0.4 , saturate( ase_vertex3Pos.y ));
				float StepMaskStar455 = ( step( lerpResult10_g12 , 0.15 ) * smoothstepResult474 );
				float temp_output_441_0 = ( smoothstepResult381 + ( pow( saturate( ( 1.0 - abs( ( break433.x * break433.y * 1.0 ) ) ) ) , 25.0 ) * 1.0 * StepMaskStar455 ) );
				float dotResult4_g14 = dot( ( FloorUV292 + float2( 8,17 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g14 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g14 ) * 43758.55 ) ));
				float StepMask341 = step( lerpResult10_g14 , _Step );
				float mulTime307 = _Time.y * _Animation;
				float RandAnim342 = (0.0 + (saturate( sin( ( ( temp_output_332_0 * 100.0 ) + mulTime307 ) ) ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
				float dotResult4_g13 = dot( ( FloorUV292 + float2( 12,4 ) ) , float2( 12.9898,78.233 ) );
				float lerpResult10_g13 = lerp( 0.0 , 1.0 , frac( ( sin( dotResult4_g13 ) * 43758.55 ) ));
				float3 hsvTorgb317 = HSVToRGB( float3((0.5 + (lerpResult10_g13 - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)),1.0,1.0) );
				float3 RandColor337 = hsvTorgb317;
				float3 temp_cast_0 = (1.0).xxx;
				float StarGrad397 = temp_output_441_0;
				float smoothstepResult401 = smoothstep( 0.25 , 1.0 , StarGrad397);
				float3 lerpResult398 = lerp( RandColor337 , temp_cast_0 , smoothstepResult401);
				float smoothstepResult324 = smoothstep( _HeightMaskMin , _HeightMaskMax , saturate( ase_vertex3Pos.y ));
				float GradMask338 = smoothstepResult324;
				float3 Star329 = ( ( ( ( temp_output_441_0 * saturate( ( 1.0 - distance( temp_output_368_0 , float2( 0,0 ) ) ) ) ) * StepMask341 * RandAnim342 ) * lerpResult398 ) * _Intensity * GradMask338 );
				float3 temp_output_277_0 = Star329;

				col.rgb += Star329;

                return col;
            }
            ENDCG
        }
    }
}
