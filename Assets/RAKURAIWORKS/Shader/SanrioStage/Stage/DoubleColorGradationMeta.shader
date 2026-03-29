Shader "Sanrio/Stage/DoubleColorGradationMeta"
{
    Properties
    {
	    [Enum(Baked,0,RealTime,1)]_GIMode("GlobalIllumination", int) = 0
        _Gradation1("Gradation1", Color) = (1,0.75,0.9843439,0)
		_UVPower("UV Power", Float) = 2.5
		_Gradation2("Gradation2", Color) = (0.5235849,0.8566347,1,0)
		_Contrast("Contrast",float) = 1.0
		_Rotate("Rotate", Range( 0 , 2)) = 0
		_EmissiveBoost("EmissiveBoost", Float) = 1
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

			uniform float _Rotate;
			uniform float _UVPower;
			uniform float4 _Gradation1;
			uniform float4 _Gradation2;
			uniform float _EmissiveBoost;
			uniform float _MetaBoost;
			uniform float _Contrast;

            float4 frag_meta2(v2f_meta i) : SV_Target
            {
                FragmentCommonData data =UNITY_SETUP_BRDF_INPUT(i.uv);
                UnityMetaInput o;
                UNITY_INITIALIZE_OUTPUT(UnityMetaInput,o);
                fixed4 c = 0;
                o.Albedo = c.rgb;

				float cos21 = cos( ( _Rotate * UNITY_PI ) );
				float sin21 = sin( ( _Rotate * UNITY_PI ) );
				float2 rotator21 = mul( i.uv - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
				float temp_output_3_0 = pow( rotator21.y , _UVPower );
				float temp_output_5_0 = pow( ( 1.0 - rotator21.y ) , _UVPower );
				float smoothstepResult15 = smoothstep( 0.0 , 1.0 , saturate( ( temp_output_3_0 + temp_output_5_0 ) ));
				float4 lerpResult16 = lerp( float4(1,1,1,0) , float4( 0.15,0.15,0.15,0 ) , smoothstepResult15);

				float3 col = ( saturate( ( lerpResult16 + ( ( _Gradation1 * temp_output_3_0 ) + ( temp_output_5_0 * _Gradation2 ) ) ) ) * _EmissiveBoost ).rgb;
				col = pow(col,_Contrast);
                o.Emission = col * _MetaBoost;
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

            uniform float _Rotate;
			uniform float _UVPower;
			uniform float4 _Gradation1;
			uniform float4 _Gradation2;
			uniform float _EmissiveBoost;
			uniform float _Contrast;

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
                float cos21 = cos( ( _Rotate * UNITY_PI ) );
				float sin21 = sin( ( _Rotate * UNITY_PI ) );
				float2 rotator21 = mul( i.uv - float2( 0.5,0.5 ) , float2x2( cos21 , -sin21 , sin21 , cos21 )) + float2( 0.5,0.5 );
				float temp_output_3_0 = pow( rotator21.y , _UVPower );
				float temp_output_5_0 = pow( ( 1.0 - rotator21.y ) , _UVPower );
				float smoothstepResult15 = smoothstep( 0.0 , 1.0 , saturate( ( temp_output_3_0 + temp_output_5_0 ) ));
				float4 lerpResult16 = lerp( float4(1,1,1,0) , float4( 0.15,0.15,0.15,0 ) , smoothstepResult15);

				float3 col = ( saturate( ( lerpResult16 + ( ( _Gradation1 * temp_output_3_0 ) + ( temp_output_5_0 * _Gradation2 ) ) ) ) * _EmissiveBoost ).rgb;
				col = pow(col,_Contrast);

                return float4(col,1.0);
            }
            ENDCG
        }
    }

    CustomEditor "MetaFixGUI"
}