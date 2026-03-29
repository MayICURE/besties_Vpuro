Shader "Noriben/noribenRainbow"
{
    Properties
    {
        [Header(Mask)]
        _Mask ("Mask", Range(0, 1)) = .5

        [Header(Brightness)]
        _RainbowIntensity ("Rainbow Intensity", Range(0, 1)) = .5
        _Rainbow2Intensity ("Secondary Rainbow Intensity", Range(0, 1)) = .05
        _InsideWhiteIntensity ("Inside White Intensity", Range(0, 1)) = .5

        [Header(Color)]
        _Hue ("Hue", Range(0, 6.28)) = 0
        _Saturation ("Saturation", Range(0, 1)) = 1

        [Header(Noise)]
        _MainTex ("Noise Tex", 2D) = "white" {}
        _NoisePower ("Noise Power", Range(0, 1)) = 0
        _NoiseSize ("Noise Size", Range(0, 50)) = 0
        _NoiseMove ("Noise Move Speed", Range(-10, 10)) = .2


        [Header(Fresnel)]
        _Fresnel ("Fresnel", Range(0, 1)) = 1
        _FresnelAngle ("Fresnel Angle", Range(0,10)) = 3

        [Header(Culling)]
        [Enum(UnityEngine.Rendering.CullMode)]
        _Cull("Cull", int) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        LOD 100
        Cull [_Cull]
        Blend one one
        Zwrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD2;
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD3;
                float3 vertexW : TEXCOORD4;
                float3 worldPos : TEXCOORD5;
                UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Mask;
            float _RainbowIntensity;
            float _Rainbow2Intensity;
            float _Fresnel;
            float _FresnelAngle;
            float _InsideWhiteIntensity;
            float _Hue;
            float _Saturation;
            float _NoisePower;
            float _NoiseSize;
            float _NoiseMove;

            //フレネル
            float fresnelFast(float3 view, float3 normal, float fresnel)
            {
                
                view = lerp(-view, view, ceil(dot(view, normal))); //メッシュの裏面もフレネルがかかるようにするための処理
                return saturate(fresnel + (1 - fresnel) * pow(dot(view, normal), _FresnelAngle));
            }


            //極座標変換
            float2 PolarUV(float2 UV, float2 Center, float RadialScale, float LengthScale)
            {
                float2 delta = UV - Center;
                float radius = length(delta) * 2 * RadialScale;
                float angle = atan2(delta.x, delta.y) * 1.0/6.2831853 * LengthScale;
                return float2(radius, angle);
            }

            //ランダム
            float rand2d (fixed2 p) { 
            return frac(sin(dot(p, fixed2(12.9898,78.233))) * 43758.5453);
            }

            //1D randam
            float rand1d(float t)
            {
                return frac(sin(t) * 54275.5453123);
            }

            
            float noise1d(float t)
            {
                float i = floor(t);
                float f = frac(t);
                return lerp(rand1d(i),rand1d(i + 1.), smoothstep(0., 1. , f));
            }


            //HSV変換
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
            

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv2 = v.uv2;
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.vertexW = mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, float4(0,0,0,1));
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);


                const float pi = 3.141592653589793;

                //極座標
                float2 uv = PolarUV(i.uv2, float2(.5,.5), 1, 1);

                //フレネル
                float3 normal = normalize(i.normal);
                float3 view = normalize(_WorldSpaceCameraPos - i.vertexW);
                float fresnel = fresnelFast(view, normal, _Fresnel);

                
                //虹の描画
                float rUV =(1.-uv.x) * 64.;
                float sR = (sin(rUV + _Hue) +1.) * 0.5;
                float sG = (sin(rUV + _Hue - pi/3. * 2.) + 1.) * 0.5;
                float sB = (sin(rUV + _Hue - pi/3. * 4.) + 1.) * 0.5;
                
                float3 sinebow = float3(sR, sG, sB);
                sinebow = saturate(sinebow);
                float gamma = 1.2;
                sinebow = pow(sinebow.xyz, float3(gamma.xxx));


                //内側の白い部分
                float whitetop = smoothstep(.45, .51, 1.-uv.x);
                float whitemask = smoothstep(.1, .7, uv.x);
                float white = whitetop * whitemask;
                white = pow(white, 1) * .5;

                //虹のマスク
                float maskbottom = smoothstep(.5,.55, uv.x);
                float masktop = smoothstep(.40, .45, 1.-uv.x);
                float mask = maskbottom * masktop;

                sinebow = (sinebow) * mask + white * _InsideWhiteIntensity;
                sinebow *= _RainbowIntensity;


                //副虹
                float rUV1 =uv.x * 64.;
                //副虹の描画
                float sR1 = (sin(rUV1 + _Hue) + 1.) * 0.5;
                float sG1 = (sin(rUV1 + _Hue - pi/3. * 2.) + 1.) * 0.5;
                float sB1 = (sin(rUV1 + _Hue - pi/3. * 4.) + 1.) * 0.5;

                float3 secondaryRainbow = float3(sR1, sG1, sB1);
                float gamma1 = 1.2;
                secondaryRainbow = pow(secondaryRainbow.xyz, float3(gamma1.xxx));


                //副虹用マスク
                float maskbottom1 = smoothstep(.8, .85, uv.x);
                float masktop1 = smoothstep(.10, .15, 1.-uv.x);
                float mask1 = maskbottom1 * masktop1;

                secondaryRainbow = secondaryRainbow * mask1 * _Rainbow2Intensity;


                //全体のマスク
                float fmask = smoothstep(_Mask, _Mask + .1, i.uv2.y);


                //mix
                float3 rainbow = (sinebow + secondaryRainbow) * fmask * fresnel;
                rainbow = saturate(rainbow);

                //HSV
                float3 hsvRainbow = rgb2hsv(rainbow);
                //hsvRainbow.x += _Hue;
                hsvRainbow.y *= _Saturation;
                float3 fixedRainbow = hsv2rgb(hsvRainbow);

                //Wave noise
                _NoiseSize = floor(_NoiseSize);
                float2 tUV = uv;

                fixed4 noiseTex01 = tex2D(_MainTex, float2(tUV.x * .05, (tUV.y +  _Time.y * .03 * _NoiseMove) * 1 * _NoiseSize));
                fixed4 noiseTex02 = tex2D(_MainTex, float2(tUV.x * .05, (tUV.y + -_Time.y * .02 * _NoiseMove) * 3 * _NoiseSize));
                fixed4 noiseTex03 = tex2D(_MainTex, float2(tUV.x * .05, (tUV.y +  _Time.y * .01 * _NoiseMove) * 6 * _NoiseSize));
                float noise = (noiseTex01.x + noiseTex02 + noiseTex03) * .33333;
                noise = pow(noise, 2.2);
                noise = saturate(noise);
                noise = lerp(1, noise, _NoisePower);

                fixedRainbow *= noise;
                fixedRainbow = saturate(fixedRainbow);

                float4 col = float4(fixedRainbow, 1);
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
