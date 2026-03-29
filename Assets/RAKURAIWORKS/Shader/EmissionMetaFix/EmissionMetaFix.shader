Shader "Unlit/EmissionMetaFix"
{
    Properties
    {
	    [Enum(Baked,0,RealTime,1)]_GIMode("GlobalIllumination", int) = 0
		_EmissionMap("Emission", 2D) = "white" {}
        [HDR]_EmissionColor("Emission Color",Color) = (0,0,0,0)
		_MetaBoost("MetaBoost",float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass{
            Name "Meta"
            Tags{"LightMode"="Meta"}
            Cull Off

            CGPROGRAM
            #include "UnityStandardMeta.cginc"

			uniform float _MetaBoost;

            float4 frag_meta2(v2f_meta i) : SV_Target
            {
                FragmentCommonData data =UNITY_SETUP_BRDF_INPUT(i.uv);
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT(UnityMetaInput,o);
                fixed4 c = 0;
                o.Albedo = c.rgb;

                o.Emission = (tex2D(_EmissionMap,i.uv) * _EmissionColor) * _MetaBoost;
                return UnityMetaFragment(o);
            }

            #pragma vertex vert_meta
            #pragma fragment frag_meta2

            ENDCG
        }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 localPos : TEXCOORD2;
            };

            float3 _EmissionColor;
			uniform sampler2D _EmissionMap;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.localPos = v.vertex;

                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = float4(tex2D(_EmissionMap,i.uv).rgb * _EmissionColor,1);

                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }

    CustomEditor "MetaFixGUI"
}