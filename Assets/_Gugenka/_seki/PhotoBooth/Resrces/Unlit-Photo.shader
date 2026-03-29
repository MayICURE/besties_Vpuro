// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Gugenka/SanrioVfes2024/PhotoBooth/Photo" {
Properties {
    _MainTex ("Base (RGB)", 2D) = "white" {}
    [HideInInspector]
    _MainTex1 ("Base (RGB) 2", 2D) = "white" {}
    _Ratio ("Ratio (Width/Height)", Float) = 1.0
    _Radius ("Corner radius", Float) = 0.0
    _p1 ("Parameter x", Float) = 0.0
    _p2 ("Parameter y", Float) = 0.0
    [HideInInspector]
    _Fade ("Fade", Float) = 1.0
}

SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass {
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata_t {
                float4 vertex : POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float2 texcoord : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _MainTex1;
            float4 _MainTex1_ST;

            float _Ratio;
            float _Radius;
            float _p1, _p2;

            float _Fade;

            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float R = _Ratio;
                float r = _Radius;
				float2 xy = (i.texcoord - 0.5) * 2;
				float x = abs(xy.x) - _p1;
				float y = abs(xy.y) - _p2;
				
				if(x > 0 && y > 0){
					if((x*x) + (y*y)/(R*R) > r)
						discard;
				}
				
                fixed4 col = tex2D(_MainTex, i.texcoord);
                fixed4 col1 = tex2D(_MainTex1, i.texcoord);

                col = lerp(col, col1, _Fade);

                UNITY_APPLY_FOG(i.fogCoord, col);
                UNITY_OPAQUE_ALPHA(col.a);
                return col;
            }
        ENDCG
    }
}

}
