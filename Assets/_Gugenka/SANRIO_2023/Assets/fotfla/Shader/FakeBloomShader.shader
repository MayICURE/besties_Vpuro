// URP-Unlit-Billboard Shader by @gam0022 (MIT Licence)
// https://gam0022.net//blog/2021/12/23/unity-urp-billboard-shader/
Shader "fotfla/FakeBloomShader"
{
    Properties
    {
        [HDR]
        _Color("Color",Color) = (1,1,1,1)
        _Size0("Size 0",Vector) = (12,1,6,1)
        _Size1("Size 1",Vector) = (12,1,6,1)
        _Rotation("Rotation",Vector) = (0,0,0,0)
        _Intensity("Intensity",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" "DisableBatching"="false"}
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma geometry geo
            #pragma target 4.0

            #include "UnityCG.cginc"
            #include "Noise.cginc"

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
                uint id : TEXCOORD2;

                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float4 _Color;

            float4 _Size0,_Size1;
            float4 _Rotation;
            float _Intensity;

            float2 rotation(float2 p, float a){
                return mul(float2x2(cos(a),sin(a),-sin(a),cos(a)),p);
            }

            v2f vert (appdata v, uint id : SV_VertexID)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                
                o.uv = v.uv;
                o.id = id;
                return o;
            }

            [maxvertexcount(4)]
            void geo(point v2f input[1], inout TriangleStream<v2f> outStream){
                v2f o;

                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_SETUP_INSTANCE_ID(input[0]);
                UNITY_TRANSFER_INSTANCE_ID(input[0], o);

                uint id = input[0].id;
                if(id > 5) return;
                id = min(id,3);
                o.id = id;

                float3 yup = float3(0,1,0);
                float3 up = mul((float3x3)unity_ObjectToWorld, yup);
                float3 wp = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
                float3 dir = normalize(_WorldSpaceCameraPos - wp);

                float3 r = normalize(cross(dir, up));
                float3 f = normalize(cross(up, r));
                float4x4 m = {1,0,0,0,
                              0,1,0,0,
                              0,0,1,0,
                              0,0,0,1};
                m._m00_m10_m20 = r;
                m._m01_m11_m21 = up;
                m._m02_m12_m22 = f;
                m._m03_m13_m23 = wp;

                float2 s = 0;
                if(id == 0){
                    s = _Size0.xy;
                } else if(id == 1){
                    s = _Size0.zw;
                } else if(id == 2){
                    s = _Size1.xy;
                } else if (id == 3){
                    s = _Size1.zw;
                }
                [unroll]
                for(int x = 0; x < 2; x++){
                    [unroll]
                    for(int y = 0; y < 2; y++){
                        o.uv = float2(x,y);
                        
                        float2 xy = rotation(float2((x - 0.5) * s.x, (y - 0.5) * s.y), UNITY_PI * _Rotation[id]);
                        float4 xyz = mul(m,float4(xy,0,1));
                        o.vertex = mul(UNITY_MATRIX_VP, float4(xyz.xyz,1));
                        outStream.Append(o);
                    }
                }

                outStream.RestartStrip();
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = _Color;
                float x = abs(i.uv.x - 0.5);
                float y = abs(i.uv.y - 0.5);
                float ny = noise12(float2(i.uv.y * 5.5 + _Time.y * 0.3, _Time.y * 0.5 + i.id));
                col.a = smoothstep(0.1,0.5, x) * smoothstep(0.5,0.0,x) * smoothstep(0.5,0.0, y) * ny * _Color.a;
                return col* _Intensity;
            }
            ENDCG
        }
    }
}
