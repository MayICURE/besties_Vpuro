// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "RAKURAIWORKS/StarNestSkybox" {
Properties {
    [Header(Common)]
    _Tint ("Tint Color", Color) = (.5, .5, .5, .5)
    [Gamma] _Exposure ("Exposure", Range(0, 8)) = 1.0
    _Rotation ("Rotation", Range(0, 360)) = 0
    [NoScaleOffset] _MainTex ("Spherical  (HDR)", 2D) = "grey" {}
    [Header(Position Setting)]
	_Position   ("Position (X.Y.Z) [全体位置]", Vector) = (1., .5, .5, 0)
	_Speed      ("Speed (X.Y.Z) [スクロール速度]", Vector) = (1., .5, .5, 0)
	[Header(Loop Setting)]
	[IntRange]_Volsteps   ("Vol Steps  (int) [全体ループ数]", Range(1, 32)) = 20
	[IntRange]_Iterations ("Iterations (int) [サブループ数]", Range(1, 32)) = 17
	[Header(Visual Setting)]
	[HDR]_Color ("Color (HDR)", Color) = (1,1,1,1)
	_Formuparam ("Formuparam", Range(0, 1)) = .53
	_Stepsize   ("Step Size [ステップサイズ]", Range(0, 2)) = 0.145
	_Zoom       ("Zoom [拡大率]", Range(0, 3)) =0.8
	_Tile       ("Tile [タイリング数]", Range(0, 1)) =0.85
	_Fade       ("Fade [暗転率]", Range(0, 2)) = .23
	_Brightness ("Brightness [輝度]",Range(0, .1)) = 0.0015
	_Darkmatter ("Darkmatter [ダークマター]",Range(0, 2)) = 0.3
	_Distfading ("Distance Fading [褪色]",Range(0, 2)) = 0.73
	_Saturation ("Saturation [彩度]",Range(0, 2)) = 0.85
	[Header(Option Setting)]
	[Toggle] _Is_Bloom("IsBloom [Blume効果無効]", Float) = 0
}

SubShader {
    Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
    Cull Off ZWrite Off

    Pass {

        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile _ _IS_BLOOM_ON

        #include "UnityCG.cginc"

        sampler2D _MainTex;
        float4 _MainTex_TexelSize;
        half4 _MainTex_HDR;
        half4 _Tint;
        half _Exposure;
        float _Rotation;
        bool _MirrorOnBack;
        int _ImageType;
        int _Layout;

        int _Iterations, _Volsteps;
		float _Formuparam, _Stepsize, _Zoom, _Tile, _Fade;
		float _Brightness,  _Darkmatter, _Distfading, _Saturation;
		float3 _Color, _Position, _Speed;

        inline float2 ToRadialCoords(float3 coords)
        {
            float3 normalizedCoords = normalize(coords);
            float latitude = acos(normalizedCoords.y);
            float longitude = atan2(normalizedCoords.z, normalizedCoords.x);
            float2 sphereCoords = float2(longitude, latitude) * float2(0.5/UNITY_PI, 1.0/UNITY_PI);
            return float2(0.5,1.0) - sphereCoords;
        }

        float3 RotateAroundYInDegrees (float3 vertex, float degrees)
        {
            float alpha = degrees * UNITY_PI / 180.0;
            float sina, cosa;
            sincos(alpha, sina, cosa);
            float2x2 m = float2x2(cosa, -sina, sina, cosa);
            return float3(mul(m, vertex.xz), vertex.y).xzy;
        }

        struct appdata_t {
            float4 vertex : POSITION;
            UNITY_VERTEX_INPUT_INSTANCE_ID
        };

        struct v2f {
            float4 vertex : SV_POSITION;
            float3 texcoord : TEXCOORD0;
            float2 image180ScaleAndCutoff : TEXCOORD1;
            float4 layout3DScaleAndOffset : TEXCOORD2;
            float3 pos : TEXCOORD3;
            UNITY_VERTEX_OUTPUT_STEREO
        };

        v2f vert (appdata_t v)
        {
            v2f o;
            UNITY_SETUP_INSTANCE_ID(v);
            UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
            float3 rotated = RotateAroundYInDegrees(v.vertex, _Rotation);
            o.vertex = UnityObjectToClipPos(rotated);
            o.pos = normalize(mul(unity_ObjectToWorld, v.vertex.xyz));
            o.texcoord = v.vertex.xyz;

            o.image180ScaleAndCutoff = float2(1.0, 1.0);
            // Calculate constant scale and offset for 3D layouts
            o.layout3DScaleAndOffset = float4(0,0,1,1);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 tc = ToRadialCoords(i.texcoord);
            if (tc.x > i.image180ScaleAndCutoff[1])
                return half4(0,0,0,1);
            tc.x = fmod(tc.x*i.image180ScaleAndCutoff[0], 1);
            tc = (tc + i.layout3DScaleAndOffset.xy) * i.layout3DScaleAndOffset.zw;
            half4 tex = tex2D (_MainTex, tc);
            half3 c = DecodeHDR (tex, _MainTex_HDR);
            c = c * _Tint.rgb * unity_ColorSpaceDouble.rgb;
            c *= _Exposure;

            float3 from = _Position + _Time.x*_Speed;
			float s = .1, fade = _Fade;
			float3 col;

			[loop]
			for(int r=0;r<_Volsteps;r++)
			{
				float3 p = from+s*i.pos*_Zoom;
				p = abs(_Tile - fmod(p, _Tile*2));
				float pa, a ;
				[loop]
				for (int i=0; i<_Iterations; i++)
				{
					p  =  abs(p) / dot(p,p) - _Formuparam;
					a  += abs(length(p) - pa);
					pa =  length(p);
				}
				float dm = max(0, _Darkmatter - pow(a, 2)*.001);
				a *= pow(a, 2);
				fade *= r > 6 ? 1-dm : 1;

				col  += float3(s, pow(s, 2), pow(s, 4))*a*_Brightness*fade;
				fade *= _Distfading;
				s    += _Stepsize;
			}
			col = lerp(length(col), col, _Saturation)*_Color*.01;
			#ifdef _IS_BLOOM_ON
			col = clamp(col, 0, 1);
            #endif

            return half4(c + col, 1);
        }
        ENDCG
    }
}
Fallback Off

}