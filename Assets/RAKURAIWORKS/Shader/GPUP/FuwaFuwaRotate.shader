Shader "Unlit/FuwaFuwaRotate"
{
	Properties
	{
	    [Header(Clip)]_ClipCount("ClipCount",range(0.0,1.0)) = 0.0
		[Header(Audio Section)][IntRange]_Band("Band", Range( 0 , 3)) = 0
		_Delay("Delay", Range( 0 , 1)) = 0
		_Emission("Emission Scale", Float) = 1
		[Header(Pulse Across UVs)]_Pulse("Pulse", Range( 0 , 1)) = 0
		_AudioHueShift("Audio Hue Shift", Float) = 0
		_PulseRotation("Pulse Rotation", Range( 0 , 360)) = 0
		[Header(Common)]
		_Seed("NoiseSeed",float) = 0
	    //[Enum(Bubble,0,Triangle,1)]_ShapeType("ShapeType", Float) = 0
		[KeywordEnum(Circle, Box, Cross, Triangle , Bubble, Sakura)] _Type ("ShapeType", Float) = 0
		[KeywordEnum(Dynamic,Rotation)] _Morph ("MorphType", Float) = 0
        _BaseScale ("Base Scale", Float) = 1.5
        _BaseRandom ("Base Randomness", Range(0,1)) = 1
        _UpperColor ("Base Color", Color) = (0,0.8,1,1)
        //_LowerColor ("Base Lower Color", Color) = (0,0.3,1,1)
        _FlapSpeed ("Flap Speed", Float) = 1
        _ParticlePower ("Particle Power", Range(0.1,1)) = 0.5
        //_ParticleColor ("Particle Bottom Color (Additive)", Color) = (0.5,0,0,1)
        _FuwaRatio ("Fuwa Ratio", Range(0,1)) = 0.95
        _FuwaColor ("Fuwa Color", Color) = (0.7,0.7,0.7,1)
        _FuwaRadius ("Fuwa Radius", Float) = 1.5
        _FuwaSpeed ("Fuwa Speed", Float) = 3
        _FuwaScale ("Fuwa Scale", Float) = 0.5
		_CurveColor ("Curve Color", Color) = (0.,0.,0.,1)
		_CurveScale("_CurveScale",float) = 1.0
		_ts("FinalIntensity",float) = 0
		_ts2("MinAlpha",Range(0.0,1.0)) = 1
		//_tex("Tex",2D) = "white" {}
		[Header(Curve)]
		_Curve("Curve",float) = 0
		_ScalingCurve("ScallingCurve",float) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="True" }
		LOD 100
        Blend SrcAlpha One
        ZWrite Off
        Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
            #pragma geometry geom
			#pragma fragment frag

			#pragma multi_compile _TYPE_CIRCLE _TYPE_BOX _TYPE_CROSS _TYPE_TRIANGLE _TYPE_BUBBLE _TYPE_SAKURA
			#pragma shader_feature _MORPH_DYNAMIC _MORPH_ROTATION
			#pragma multi_compile_instancing


			#define PI 3.14159265359
			#define TWO_PI 6.28318530718

			const float SQRT_2 = 1.4142135623730951;

			
			#include "UnityCG.cginc"
			#include "Assets/AudioLink/Shaders/AudioLink.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 projPos : TEXCOORD3;
				float2 uv2 : TEXCOORD4;
				float2 angleStep : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float _BaseScale, _BaseRandom, _FlapSpeed, _ParticlePower;
			float4 _UpperColor, _LowerColor, _ParticleColor, _FuwaColor,_CurveColor;
            float _FuwaRatio, _FuwaRadius, _FuwaSpeed, _FuwaScale;
			float _CurveScale,_Hue;
			float _ShapeType;
			float _ts,_ts2;
			float _Seed;
			float _ClipCount;

			uniform float _Curve = 0.0;
			uniform float _ScalingCurve = 0.0;

			sampler2D _CameraDepthTexture;
			sampler2D _tex;

			UNITY_INSTANCING_BUFFER_START(AudioLinkSurfaceAudioReactiveSurface)
				UNITY_DEFINE_INSTANCED_PROP(float, _Band)
#define _Band_arr AudioLinkSurfaceAudioReactiveSurface
				UNITY_DEFINE_INSTANCED_PROP(float, _PulseRotation)
#define _PulseRotation_arr AudioLinkSurfaceAudioReactiveSurface
				UNITY_DEFINE_INSTANCED_PROP(float, _Pulse)
#define _Pulse_arr AudioLinkSurfaceAudioReactiveSurface
				UNITY_DEFINE_INSTANCED_PROP(float, _Delay)
#define _Delay_arr AudioLinkSurfaceAudioReactiveSurface
				UNITY_DEFINE_INSTANCED_PROP(float, _AudioHueShift)
#define _AudioHueShift_arr AudioLinkSurfaceAudioReactiveSurface
				UNITY_DEFINE_INSTANCED_PROP(float, _Emission)
#define _Emission_arr AudioLinkSurfaceAudioReactiveSurface
			UNITY_INSTANCING_BUFFER_END(AudioLinkSurfaceAudioReactiveSurface)
            
			appdata vert (appdata v) {
                return v;
			}

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}

            float rand(float2 co){
                return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453 + _Seed);
            }

			float2x2 rotate2d(float angle){
				return float2x2(cos(angle),-sin(angle),sin(angle),cos(angle));
			}

			inline float3x3 xRotation3dRadians(float rad) {
				float s = sin(rad);
				float c = cos(rad);
				return float3x3(
					1, 0, 0,
					0, c, s,
					0, -s, c);
			}
 
			inline float3x3 yRotation3dRadians(float rad) {
				float s = sin(rad);
				float c = cos(rad);
				return float3x3(
					c, 0, -s,
					0, 1, 0,
					s, 0, c);
			}
 
			inline float3x3 zRotation3dRadians(float rad) {
				float s = sin(rad);
				float c = cos(rad);
				return float3x3(
					c, s, 0,
					-s, c, 0,
					0, 0, 1);
			}

			inline float AudioLinkLerp3_g6( int Band, float Delay )
			{
				return AudioLinkLerp( ALPASS_AUDIOLINK + float2( Delay, Band ) ).r;
			}

            [maxvertexcount(12)]
            void geom(triangle appdata IN[3], inout TriangleStream<v2f> stream) {
                // adjust scale by density
                float area = pow(length(cross(IN[0].vertex.xyz - IN[1].vertex.xyz, IN[1].vertex.xyz - IN[2].vertex.xyz)), 0.4) * 15;

                float2 uvs[4] = {
                    float2(-1,-1),
                    float2(-1,1),
                    float2(1,-1),
                    float2(1,1)
                };

				float2 uvs2[4] = {
                    float2(0,0),
                    float2(0,1),
                    float2(1,0),
                    float2(1,1)
                };

                v2f o;

				UNITY_INITIALIZE_OUTPUT(v2f, o);
				UNITY_SETUP_INSTANCE_ID(IN[0]);
                UNITY_TRANSFER_INSTANCE_ID(IN[0], o);

				//AudioLink
				float _Band_Instance = UNITY_ACCESS_INSTANCED_PROP(_Band_arr, _Band);
				int Band3_g6 = (int)_Band_Instance;
				float _Pulse_Instance = UNITY_ACCESS_INSTANCED_PROP(_Pulse_arr, _Pulse);
				float _Delay_Instance = UNITY_ACCESS_INSTANCED_PROP(_Delay_arr, _Delay);
				float Delay3_g6 = ( ( (_Delay_Instance + (( 0.0 * _Pulse_Instance ) - 0.0) * (1.0 - _Delay_Instance) / (1.0 - 0.0)) % 1.0 ) * 128.0 );
				float localAudioLinkLerp3_g6 = AudioLinkLerp3_g6( Band3_g6 , Delay3_g6 );

				float ColorCurve = _Curve;
				float Hue = (_Time.y * 0.1) + (localAudioLinkLerp3_g6 * 0.2);
				float3 HSVColor = HSVToRGB(float3(Hue,0.7,1.0));

                // generate 1 particle per vertex
                for(int j=0;j<1;j++) {
                    float4 iv = IN[j].vertex;
                    float2 uv = iv.xy*10; // approximately range [-1,1]
                    float2 seed = uv + area + j; // random seed
                    bool fuwa = rand(seed) > _FuwaRatio;
					bool angle = rand(seed + float2(0.2,0.5)) > 0.6;
					bool clip = rand(seed + float2(0.3,0.6)) > _ClipCount;

                    float a = pow(sin(_Time.y * 0.5) * 0.3 + 0.7, 2) * 0.7 + 0.3; // animation curve

					#ifdef _MORPH_DYNAMIC
					  a += (_ScalingCurve * localAudioLinkLerp3_g6) * 1.0;
					#elif _MORPH_ROTATION
					  a += 1.5;
					#endif
                   

                    float r0 = rand(seed+0);
                    float r1 = rand(seed+1);
                    float r2 = rand(seed+2);
                    float r3 = rand(seed+3);


                    if(fuwa) {
                        // random local rotation
                        float speed = 0.1 * _FuwaSpeed;
						speed *= _BaseRandom;
                        float radius = ((0.015 * _FuwaRadius) * a) * _BaseRandom;

                        float3 dif = float3(0,1,0);
                        a = speed*(r0+1)*_Time.y+lerp(r1,r2,_Curve);
                        dif.xy = mul(float2x2(cos(a),sin(a),-sin(a),cos(a)), dif.xy);
                        a = speed*(r2+1)*_Time.y+lerp(r3,r0,_Curve);
                        dif.yz = mul(float2x2(cos(a),sin(a),-sin(a),cos(a)), dif.yz);
						//iv.xy += (dif*radius) * 0.05;
                        //iv.z += (dif*radius) * 0.6;
						//iv.z += mul(unity_ObjectToWorld, float4((dif*radius) * 0.1, 1)).xyz;
						iv.xz += (dif*radius) * 0.1;
						iv.y += (dif*radius) * 0.1;
                    }

					if(!fuwa){
					    //float a2 = pow(sin(_Time.y * 0.15) * 0.3 + 0.7, 2) * 0.7 + 0.3; // animation curve
						float randomness = _BaseRandom;
						randomness *= 5.0;
						//randomness *= lerp(0.0,1.0,_Curve);
						iv.x += (sin(r2*_Time.y+r2) * 0.01) * randomness;

						iv.y += (sin(r1*_Time.y+r3) * 0.01) * randomness;
		
						iv.z += (sin(r3*_Time.y+r1) * 0.01) * randomness;
	

						iv.xyz *= 1.0;
					}
					
                    float4 wp = mul(UNITY_MATRIX_M, iv); // world space position

                    float scale = length(mul((float3x3)UNITY_MATRIX_M, float3(0,1,0))); // get scale from Y axis
                    float size = scale * area * 0.01 * _BaseScale // base scale
                               * lerp(1, lerp(1,0.8,r0) * (sin(r2*_Time.y+r0)*0.5+1), _BaseRandom) // randomness
                               * (fuwa ? _FuwaScale : 1); // fuwa
                    float3 vp = mul(UNITY_MATRIX_V, wp).xyz; // view space position
                    
                    // billboard generation
                    for(int i=0;i<4;i++) {
                        float3 p = vp + float3(uvs[i],0) * size; // view space shift
						o.worldPos.xyz = wp.xyz;
                        o.uv = uvs[i];
						o.uv2 = uvs2[i];
                        o.vertex = mul(UNITY_MATRIX_P, float4(p,1));
						//o.vertex = UnityObjectToClipPos(iv + float3(uvs[i],0) * size);
						o.projPos = ComputeScreenPos(o.vertex);
                        o.projPos.z = - o.vertex.z;


                        o.color.rgb = lerp(_UpperColor.rgb,HSVColor.rgb,0.0);
						o.color.a = r2;
                        //o.color += _ParticleColor * lerp(1,0,o.uv.y*0.5+0.5);
                        if(fuwa) o.color.rgb = lerp(_FuwaColor,HSVColor,1.0);

						if(angle){
							o.angleStep.x = 0.0;
						}
						else{
							o.angleStep.x = 1.0;
						}

						if(clip){
							o.angleStep.y = 1.0;
						}
						else{
							o.angleStep.y = 0.0;
						}

                        stream.Append(o);
                    }
                    stream.RestartStrip();
                }
            }
			
			fixed4 frag (v2f i) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);

				//AudioLink
				float _Band_Instance = UNITY_ACCESS_INSTANCED_PROP(_Band_arr, _Band);
				int Band3_g6 = (int)_Band_Instance;
				float _Pulse_Instance = UNITY_ACCESS_INSTANCED_PROP(_Pulse_arr, _Pulse);
				float _Delay_Instance = UNITY_ACCESS_INSTANCED_PROP(_Delay_arr, _Delay);
				float Delay3_g6 = ( ( (_Delay_Instance + (( 0.0 * _Pulse_Instance ) - 0.0) * (1.0 - _Delay_Instance) / (1.0 - 0.0)) % 1.0 ) * 128.0 );
				float localAudioLinkLerp3_g6 = AudioLinkLerp3_g6( Band3_g6 , Delay3_g6 );

			    float2 uv = i.uv;
				float2 uv2 = i.uv2 - 0.5;
				float angle = (sin(_Time.y * i.color.a) * PI) * 1.5;
				angle += (sin(_Time.y * i.color.a) * PI) + (i.color.a * 5.0);
				//angle += (localAudioLinkLerp3_g6 * i.angleStep) * 10.0;
				uv = mul(uv,rotate2d(angle));
				uv2 = mul(uv2,rotate2d(angle)) + 0.5;

				
			    #ifdef _TYPE_CIRCLE
					float d = length(uv);
					d = pow(d,2.5);
					clip(1 - d);
					float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
				#elif _TYPE_BOX
					float2 sizeX = float2(0.3,0.3);
					float2 leftbottomX = float2(0.5,0.5) - sizeX * 0.5;
					float2 boxuvX = step(leftbottomX, uv2);
					boxuvX *= step(leftbottomX, 1-uv2);
					float Box = boxuvX.x*boxuvX.y;

				    float alpha = Box;
				#elif _TYPE_CROSS
				    float2 sizeX = float2(0.5,0.15);
					float2 leftbottomX = float2(0.5,0.5) - sizeX * 0.5;
					float2 boxuvX = step(leftbottomX, uv2);
					boxuvX *= step(leftbottomX, 1-uv2);
					float X = boxuvX.x*boxuvX.y;

					float2 sizeY = float2(0.15,0.5);
					float2 leftbottomY = float2(0.5,0.5) - sizeY * 0.5;
					float2 boxuvY = step(leftbottomY, uv2);
					boxuvY *= step(leftbottomY, 1-uv2);
					float Y = boxuvY.x*boxuvY.y;

				    float alpha = saturate(X + Y);
				#elif _TYPE_TRIANGLE
				    float a = atan2(uv.x,uv.y) + PI;
					float r = TWO_PI / float(3);
					float d = cos(floor(0.5 + a / r) * r - a) * length(uv);
					d = smoothstep(0.35,0.41,d);
					clip(d);
					float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
				#elif _TYPE_BUBBLE
				    float d = length(uv);
					d = 1.0 - pow(d,5.0);
					clip(d);
					float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
				#elif _TYPE_SAKURA
					float a = atan2(uv.y, uv.x);
					float d = min(abs(cos(a * 2.5)) + 0.4,
										abs(sin (a * 2.5)) + 1.1) * 0.32;
					float r = length(uv);
					d = 1.0 - step(r, d);
					float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
				#endif
			

				// Soft particle
                float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos);
	            float3 forward = normalize(mul(transpose((float3x3)UNITY_MATRIX_V), float3(0,0,-1)));
	            float3 eyeViewDir = viewDir / dot(viewDir, forward);
                float eyeDepth = LinearEyeDepth(tex2D(_CameraDepthTexture, i.projPos.xy / i.projPos.w));
	            float3 collision = _WorldSpaceCameraPos + eyeViewDir * eyeDepth;
                float depth = distance(collision, i.worldPos);

				
				alpha *= smoothstep(0,1,saturate(depth));

				float worldDist = distance(i.worldPos, _WorldSpaceCameraPos);
                alpha *= smoothstep(0.1, 0.4, worldDist);

				float finalAlpha = saturate(alpha * (localAudioLinkLerp3_g6 + _ts2));

				return float4((i.color.rgb + (i.color.a * 0.5)) * (5.0 + lerp(localAudioLinkLerp3_g6 * _ts,0.0,i.angleStep.x)),lerp(finalAlpha,saturate(alpha),i.angleStep.x) * i.angleStep.y);
			}
			ENDCG
		}
	}
}
