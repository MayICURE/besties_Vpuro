Shader "Sanrio/HideUnderAngle"
{
    Properties
    {
        [HideInInspector]_MainTex ("Texture", 2D) = "white" {}
		_Color("Color",Color) = (1,1,1,1)
		[Enum(fade,0,clip,1)]_HideType("HideType", int) = 0
		[Header(Fade)]
		_AngleMin("AngleMin",Range(0,1)) = 0.0 
		_AngleMax("AngleMax",Range(0,1)) = 1.0
		[Header(Clip)]
		_ClipLine("ClipLine",Range(0,1)) = 0.5

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent"}
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off

        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float _ClearLine;
			float _VisiblePos;

			float4 _Color;

			float _AngleMin,_AngleMax,_ClipLine;
			int _HideType;

			float linearstep(float a, float b, float x)
			{
				return saturate((x - a) / (b - a));
			}

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
			    fixed4 col = _Color;

				float4 objPos =mul(unity_ObjectToWorld, float4(0,0,0,1)); // オブジェクトの座標
				float cameraPosHugou = lerp(1, -1, _WorldSpaceCameraPos.y < objPos.y); // カメラがオブジェクトより下にあるとき負値に
				float CameraRot = UNITY_MATRIX_V._m11; //カメラのx軸z軸回転

				if(cameraPosHugou > 0.0){
					CameraRot = 1.0;
				}

				float Angle;
				Angle = lerp(linearstep(_AngleMin,_AngleMax,CameraRot),step(_ClipLine,CameraRot),_HideType);

				col.a = 1.0 - Angle;

                return col;
            }
            ENDCG
        }
    }
}
