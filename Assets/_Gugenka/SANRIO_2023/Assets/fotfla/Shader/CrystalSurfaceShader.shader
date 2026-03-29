Shader "fotfla/CrystalSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _RefracltionIndex("Refraction Index", float) = 1.1
        _Distance("Distance", float) = 1
        _RGBShift("RGB Shift",float) = 0.05
        _PhaseShift("Phase Shift",Range(0,1)) = 0
        [HDR]
        _EmissionColor("Emission Color", Color) = (0,0,0)
        _EmissionIntensity("Emission Intensity",Range(0,1)) = 1
    }
    SubShader
    {
        GrabPass {"_CameraColorTexture"}

        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha:fade

        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
            float4 screenPos;
            float3 viewDir;
            float3 worldNormal;
            float3 worldPos;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        float _RefracltionIndex;
        float _Distance;
        float _RGBShift;
        float _PhaseShift;
        float3 _EmissionColor;
        float _EmissionIntensity;

        sampler2D _CameraColorTexture;

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        float2 screenPosRGB(float3 viewDir, float3 worldPos, float3 worldNormal, float c){
            float3 refrDir = refract(viewDir, worldNormal , 1/(_RefracltionIndex + c));

            float3 refrPos = worldPos + refrDir * _Distance;
            float4 refractScreenPos = mul(UNITY_MATRIX_VP, float4(refrPos,1));
            float4 sp = ComputeScreenPos(refractScreenPos);
            return sp.xy / sp.w;
        }

        float3 refractionColor(float4 screenPos, float3 worldPos, float3 viewDir, float3 worldNormal){
            float a = _RGBShift;
            float2 sp1 = screenPosRGB(viewDir, worldPos, worldNormal,-a);
            float2 sp2 = screenPosRGB(viewDir, worldPos, worldNormal,a * 1.1);
            float3 cct1 = tex2D(_CameraColorTexture, sp1);
            float3 cct2 = tex2D(_CameraColorTexture, sp2) * 0.5;
            return cct1 + cct2;
        }

        float3 hsv2rgb(float3 c) {
            float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
            float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);
            return c.z *lerp(K.xxx, saturate(p - K.xxx), c.y);
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex).rrrr;
            float2 vN = mul((float3x3)UNITY_MATRIX_V, IN.worldNormal).xy * 0.5 + 0.5;
            c.rgb *= hsv2rgb(float3(atan2(vN.y, vN.x) + _PhaseShift + c.r + _Time.y * 0.1, c.r,1.0));
            c.rgb += refractionColor(IN.screenPos, IN.worldPos, IN.viewDir, IN.worldNormal);
            o.Albedo = c * _Color;
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = _Color.a;
            o.Emission = c * _Color + _EmissionColor * _EmissionIntensity;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
