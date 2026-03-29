Shader "Unlit/butterfly_particle"
{
	Properties
	{
	    [Header(finalColor)]
		[HDR]_finalColor("finalColor",color) = (1,1,1,1)
		_finalAlpha("finalAlpha",Range(0.0,1.0)) = 1.0
		_clipCount("ClipCount",Range(0,1)) = 0
		_seed("seed",float) = 0
		[Header(Common)]
        [KeywordEnum(CIRCLE, BUBBLE,TRIANGLE,BOX,CROSS)] _Type ("ShapeType", Float) = 0
        _BaseScale ("Base Scale", Float) = 1.5
        _BaseRandom ("Base Randomness", Range(0,1)) = 1
        _UpperColor ("Base Upper Color", Color) = (0,0.8,1,1)
        _LowerColor ("Base Lower Color", Color) = (0,0.3,1,1)
        _FlapSpeed ("Flap Speed", Float) = 1
        _ParticlePower ("Particle Power", Range(0.3,1)) = 0.5
        _ParticleColor ("Particle Bottom Color (Additive)", Color) = (0.5,0,0,1)
        _FuwaRatio ("Fuwa Ratio", Range(0,1)) = 0.95
        _FuwaColor ("Fuwa Color (Additive)", Color) = (0.7,0.7,0.7,1)
        _FuwaRadius ("Fuwa Radius", Float) = 1.5
        _FuwaSpeed ("Fuwa Speed", Float) = 3
        _FuwaScale ("Fuwa Scale", Float) = 0.5
        _MainTex("BaseTexture", 2D) = "white" {}
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

            #pragma shader_feature _TYPE_CIRCLE _TYPE_BUBBLE _TYPE_TRIANGLE _TYPE_BOX _TYPE_CROSS

            #define PI 3.14159265359
            #define TWO_PI 6.28318530718
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
				float4 projPos : TEXCOORD3;
                float2 uv2 : TEXCOORD4;
				float clipCheck : TEXCOORD5;
			};

            float _BaseScale, _BaseRandom, _FlapSpeed, _ParticlePower;
			float4 _UpperColor, _LowerColor, _ParticleColor, _FuwaColor;
            float _FuwaRatio, _FuwaRadius, _FuwaSpeed, _FuwaScale;

            sampler2D _CameraDepthTexture;
            sampler2D _MainTex;

			float4 _finalColor;
			float _clipCount;
			float _seed;
			float _finalAlpha;
            
			appdata vert (appdata v) {
                return v;
			}

            float rand(float2 co){
                return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453 + _seed);
            }

            [maxvertexcount(12)]
            void geom(triangle appdata IN[3], inout TriangleStream<v2f> stream) {
                // adjust scale by density
                float area = pow(length(cross(IN[0].vertex.xyz - IN[1].vertex.xyz, IN[1].vertex.xyz - IN[2].vertex.xyz)), 0.4) * 40;

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
                // generate 1 particle per vertex
                for(int j=0;j<3;j++) {
                    float4 iv = IN[j].vertex; // input vertex
                    float2 uv = iv.xy*10; // approximately range [-1,1]
                    float2 seed = uv + area + j; // random seed
                    bool fuwa = rand(seed) > _FuwaRatio;
					bool clip = rand(seed) > _clipCount;

                    float a = pow(sin(_Time.y * _FlapSpeed) * 0.3 + 0.7, 2) * 0.7 + 0.3; // animation curve
                    a += - 0.1 * lerp(0,1,smoothstep(0.4,1,abs(uv.x))); // slightly bend wings
                    a *= - sign(uv.x) * 1.2; // direction
                    //iv.xz = mul(float2x2(cos(a),sin(a),-sin(a),cos(a)), iv.xz); // rotate around local Y axis

                    float r0 = rand(seed+0);
                    float r1 = rand(seed+1);
                    float r2 = rand(seed+2);
                    float r3 = rand(seed+3);
                    if(fuwa) {
                        // random local rotation
                        float speed = 0.1 * _FuwaSpeed;
                        float radius = 0.01 * _FuwaRadius;
                        float3 dif = float3(1,0,0);
                        a = speed*(r0+1)*_Time.y+r1;
                        dif.xy = mul(float2x2(cos(a),sin(a),-sin(a),cos(a)), dif.xy);
                        a = speed*(r2+1)*_Time.y+r3;
                        dif.yz = mul(float2x2(cos(a),sin(a),-sin(a),cos(a)), dif.yz);
                        iv.xyz += dif*radius;
                    }
                    iv.xyz += float3(
                        sin(r2*_Time.y+r2) * 0.002,
                        sin(r1*_Time.y+r3) * 0.002,
                        sin(r3*_Time.y+r1) * 0.003) * _BaseRandom;
                    float4 wp = mul(UNITY_MATRIX_M, iv); // world space position

                    float scale = length(mul((float3x3)UNITY_MATRIX_M, float3(0,1,0))); // get scale from Y axis
                    float size = scale * area * 0.01 * _BaseScale // base scale
                               * lerp(1, lerp(1,0.8,r0) * (sin(r2*_Time.y+r0)*0.5+1), _BaseRandom) // randomness
                               * (fuwa ? _FuwaScale : 1); // fuwa
                    float3 vp = mul(UNITY_MATRIX_V, wp).xyz; // view space position
                    
                    // billboard generation
                    for(int i=0;i<4;i++) {
                        float3 p = vp + float3(uvs[i],0) * size; // view space shift
                        o.worldPos = wp.xyz;
                        o.uv = uvs[i];
                        o.uv2 = uvs2[i];
                        o.vertex = mul(UNITY_MATRIX_P, float4(p,1));
                        o.color.rgb = lerp(_UpperColor, _LowerColor, smoothstep(1.5,-1.5,uv.y) + (r2 - 0.5) * 0.2);
                        o.color.rgb += _ParticleColor * lerp(1,0,o.uv.y*0.5+0.5);
                        o.color.a = r3;
						if(clip){
							o.clipCheck = 1.0;
						}
						else{
							o.clipCheck = 0.0;
						}
                        o.projPos = ComputeScreenPos(o.vertex);
                        o.projPos.z = - o.vertex.z;

                        if(fuwa) o.color += _FuwaColor;
                        stream.Append(o);
                    }
                    stream.RestartStrip();
                }
            }
			
			fixed4 frag (v2f i) : SV_Target
			{
                float2 uv = i.uv;
                float2 uv2 = i.uv2;

                float angle = sin(_Time.y * i.color.a) * PI;
                angle += i.color.a;
                float2x2 ro = float2x2(cos(angle),-sin(angle),sin(angle),cos(angle));

                uv = mul(uv,ro);
                uv2 = mul(uv2 - 0.5, ro) + 0.5;

                #ifdef _TYPE_CIRCLE
                    float d = length(uv);
                    d = pow(d,2.5);
                    clip(1 - d);
                    float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
                #elif _TYPE_BUBBLE
                    float d = length(uv);
                    d = 1.0 - pow(d,6.0);
                    clip(d);
                    float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
                    //float2 st = 0.5 - uv2;
                    //float a = atan2(st.y, st.x);
                    //float d = min(abs(cos(a * 2.5)) + 0.4,
                    //abs(sin (a * 2.5)) + 1.1) * 0.32;
                    //float r = length(st);
                    //float alpha = step(r,d);
                    //d = step(r,d);
                #elif _TYPE_TRIANGLE
                    float a = atan2(uv.x,uv.y)+PI;
                    float r = TWO_PI/float(3);
                    float d = cos(floor(.5+a/r)*r-a)*length(uv);
                    d = smoothstep(.4,.41,d);
                    clip(d);
                    float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
                #elif _TYPE_BOX
                    float2 size = float2(0.5,0.5);
                    float2 leftbottom = float2(0.5,0.5) - size * 0.5;
                    float2 boxuv = step(leftbottom, uv2);
                    boxuv *= step(leftbottom, 1-uv2);
                    float d = 1.0 - boxuv.x * boxuv.y;
                    float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
                #elif _TYPE_CROSS
                    float2 sizeX = float2(0.3,0.1);
                    float2 leftbottomX = float2(0.5,0.5) - sizeX * 0.5;
                    float2 boxuvX = step(leftbottomX, uv2);
                    boxuvX *= step(leftbottomX, 1-uv2);
                    float X = boxuvX.x * boxuvX.y;

                    float2 sizeY = float2(0.1,0.3);
                    float2 leftbottomY = float2(0.5,0.5) - sizeY * 0.5;
                    float2 boxuvY = step(leftbottomY, uv2);
                    boxuvY *= step(leftbottomY, 1-uv2);
                    float Y = boxuvY.x * boxuvY.y;

                    float d = 1.0 - saturate(X+Y);
                    float alpha = pow(1-d,1/_ParticlePower)*exp(-d*2);
                #endif

                float4 col = tex2D(_MainTex,uv2);

                // Soft particle
                float3 viewDir = normalize(i.worldPos - _WorldSpaceCameraPos);
	            float3 forward = normalize(mul(transpose((float3x3)UNITY_MATRIX_V), float3(0,0,-1)));
	            float3 eyeViewDir = viewDir / dot(viewDir, forward);
                float eyeDepth = LinearEyeDepth(tex2D(_CameraDepthTexture, i.projPos.xy / i.projPos.w));
	            float3 collision = _WorldSpaceCameraPos + eyeViewDir * eyeDepth;
                float depth = distance(collision, i.worldPos);

				
				//alpha *= smoothstep(0,1,saturate(depth));

				alpha *= sin((_Time.y * 1.5) * i.color.a) * 0.5 + 0.5;
				alpha *= _finalAlpha;

				return float4(_finalColor.rgb,alpha * i.clipCheck);
			}
			ENDCG
		}
	}
}
