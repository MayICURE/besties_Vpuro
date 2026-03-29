#ifndef NOISE_INCLUDED
#define NOISE_INCLUDED

int baseHash(int2 p){
	p = 1103515245*((p >> 1)^(p.yx));
    int h32 = 1103515245*((p.x)^(p.y>>3));
    return h32^(h32 >> 16);
}

float hash12(int2 x){
	int n = baseHash(x);
	return (float)n * (2.0/(float)0xffffffff);
}

float noise(float2 uv){
	int2 i = floor(uv);
	float2 f = uv - i;

	float a0 = hash12(i + int2(0,0));
	float a1 = hash12(i + int2(1,0));
	float a2 = hash12(i + int2(0,1));
	float a3 = hash12(i + int2(1,1));

	float2 u = f * f * (3.0 - 2.0 * f);

	return lerp(lerp(a0,a1,u.x),lerp(a2,a3,u.x),u.y);
}

//--------------------------------------------------------------

uint baseHash(uint p){
    const uint u = 1103515245U;
    p = u * ((p >> 1U) ^ p);
    uint h32 = u * ((p) ^ (p >> 3U));
    return h32^(h32>>16);
}

uint baseHash(uint2 p){
    const uint u = 1103515245U;
    p = u * ((p.xy >> 1U) ^ p.yx);
    uint h32 = u * ((p.x) ^ (p.y >> 3U));
    return h32^(h32>>16);
}

uint baseHash(uint3 p){
    const uint u = 1103515245U;
    p = u*((p.xyz >> 1U)^(p.yzx));
    uint h32 = u*((p.x^p.z)^(p.y>>3U));
    return h32^(h32 >> 16);
}

float hash11(uint p){
    uint n = baseHash(p);
    return (float)n * (1.0/float(0xffffffffU)); 
}

float2 hash21(uint p){
    uint n = baseHash(p);
    uint2 rz = uint2(n, n * 48271U);
    return float2( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float3 hash31(uint p){
    uint n = baseHash(p);
    uint3 rz = uint3(n, n * 18807U,n * 48271U);
    return float3( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float hash12(uint2 p){
    uint n = baseHash(p);
    return (float)n * (1.0/float(0xffffffffU)); 
}

float2 hash22(uint2 p){
    uint n = baseHash(p);
    uint2 rz = uint2(n, n * 48271U);
    return float2( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float3 hash32(uint2 p){
    uint n = baseHash(p);
    uint3 rz = uint3(n, n * 18807U,n * 48271U);
    return float3( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float hash13(uint3 x){
    uint n = baseHash(x);
    return (float)n * (1.0/float(0xffffffffU));
}

float2 hash23(uint3 x){
    uint n = baseHash(x);
    uint2 rz = uint2(n, n * 48271U);
    return float2( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float3 hash33(uint3 x){
    uint n = baseHash(x);
    uint3 rz = uint3(n, n * 18807U,n * 48271U);
    return float3( (rz >> 1) & 0x7fffffffU ) / float(0x7fffffffU);
}

float noise12(float2 p){
    uint2 i = floor(p);
	float2 f = p - i;

	float a0 = hash12(i + uint2(0,0));
	float a1 = hash12(i + uint2(1,0));
	float a2 = hash12(i + uint2(0,1));
	float a3 = hash12(i + uint2(1,1));

	float2 u = f * f * (3.0 - 2.0 * f);

	return lerp(lerp(a0,a1,u.x),lerp(a2,a3,u.x),u.y);
}

float noise13(float3 p){
    uint3 i = floor(p);
    float3 f =  frac(p);

    float a0 = hash13(i + uint3(0,0,0));
    float a1 = hash13(i + uint3(1,0,0));
    float a2 = hash13(i + uint3(0,1,0));
    float a3 = hash13(i + uint3(1,1,0));
    float a4 = hash13(i + uint3(0,0,1));
    float a5 = hash13(i + uint3(1,0,1));
    float a6 = hash13(i + uint3(0,1,1));
    float a7 = hash13(i + uint3(1,1,1));

    float3 u = f * f * (3.0 - 2.0 * f);

    return lerp(lerp(lerp(a0,a1,u.x),lerp(a2,a3,u.x),u.y),lerp(lerp(a4,a5,u.x),lerp(a6,a7,u.x),u.y),u.z);
}

float noiseGrad13(float3 uv){
    uint3 i = floor(uv);
    float3 f = frac(uv);

    float3 u = f * f * f *(f * (f * 6.0 - 15.0) + 10.0);

    float3 a0 = hash33(i + uint3(0,0,0)) * 2.0 - 1.0;
    float3 a1 = hash33(i + uint3(1,0,0)) * 2.0 - 1.0;
    float3 a2 = hash33(i + uint3(0,1,0)) * 2.0 - 1.0;
    float3 a3 = hash33(i + uint3(1,1,0)) * 2.0 - 1.0;
    float3 a4 = hash33(i + uint3(0,0,1)) * 2.0 - 1.0;
    float3 a5 = hash33(i + uint3(1,0,1)) * 2.0 - 1.0;
    float3 a6 = hash33(i + uint3(0,1,1)) * 2.0 - 1.0;
    float3 a7 = hash33(i + uint3(1,1,1)) * 2.0 - 1.0;

    float b0 = dot(a0,f - float3(0,0,0));
    float b1 = dot(a1,f - float3(1,0,0));
    float b2 = dot(a2,f - float3(0,1,0));
    float b3 = dot(a3,f - float3(1,1,0));
    float b4 = dot(a4,f - float3(0,0,1));
    float b5 = dot(a5,f - float3(1,0,1));
    float b6 = dot(a6,f - float3(0,1,1));
    float b7 = dot(a7,f - float3(1,1,1));

    return b0 + 
           u.x * (b1 - b0) + 
           u.y * (b2 - b0) + 
           u.z * (b4 - b0) + 
           u.x * u.y * (b0 - b1 - b2 + b3) + 
           u.y * u.z * (b0 - b2 - b4 + b6) +
           u.z * u.x * (b0 - b1 - b4 + b5) +
           u.x * u.y * u.z * (-b0 + b1 + b2 - b3 + b4 -b5 - b6 + b7);
}

//--------------------------------------------------------------

float hash(float uv){
    return frac(45315.53612 * sin(uv * 12.599));
}

float hash(float2 uv){
    return frac(45315.53612 * sin(dot(uv,float2(12.599,78.8989))));
}

float hash(float3 uv){
    return frac(45315.53612 * sin(dot(uv,float3(12.599,78.8989,126.54254))));
}

float2 hash2(float2 uv){
    return float2( hash(uv), hash(uv + 1) );
}

float3 hash3(float3 uv){
    return float3(hash(uv),hash(uv + 1),hash(uv + 2));
}

float2 vnoise(float2 uv){
    float2 i = floor(uv);
    float2 f = frac(uv);

    float2 a0 = hash(i + float2(0,0));
    float2 a1 = hash(i + float2(1,0));
    float2 a2 = hash(i + float2(0,1));
    float2 a3 = hash(i + float2(1,1));

    float2 u = f * f * (3.0 - 2.0 * f);

    return lerp(lerp(a0,a1,u.x),lerp(a2,a3,u.x),u.y);
}

float3 noise3(float2 uv){
    return float3(noise(uv),noise(uv + 1),noise(uv + 2));
}

float noise(float3 uv){
    float3 i = floor(uv);
    float3 f =  frac(uv);

    float a0 = hash(i + float3(0,0,0));
    float a1 = hash(i + float3(1,0,0));
    float a2 = hash(i + float3(0,1,0));
    float a3 = hash(i + float3(1,1,0));
    float a4 = hash(i + float3(0,0,1));
    float a5 = hash(i + float3(1,0,1));
    float a6 = hash(i + float3(0,1,1));
    float a7 = hash(i + float3(1,1,1));

    float3 u = f * f * (3.0 - 2.0 * f);

    return lerp(lerp(lerp(a0,a1,u.x),lerp(a2,a3,u.x),u.y),lerp(lerp(a4,a5,u.x),lerp(a6,a7,u.x),u.y),u.z);
}

//----------------------------------------------------------------------

// Worley Noise
float wnoise(float2 uv){
    float2 i = floor(uv);
    float2 f = frac(uv);

    float mind = 1.0;
    [unroll]
    for(int x = -1; x <= 1; x++){
        [unroll]
        for(int y = -1; y <= 1; y++){
            float2 n = float2(x,y);
            float2 p = hash22(i + n);
            float2 d = n + p - f;
            float dist = length(d);
            mind = min(mind,dist);
        }
    }
    return mind;
}

float wnoise(float3 uv){
    float3 i = floor(uv);
    float3 f = frac(uv);

    float mind = 100.0;
    [unroll]
    for(int x = -1; x <= 1; x++){
        [unroll]
        for(int y = -1; y <= 1; y++){
            [unroll]
            for(int z = -1; z <= 1; z++){
                float3 n = float3(x,y,z);
                float3 p = hash33(uint3(i + n));
                float3 d = n + p - f;
                float dist = length(d);
                mind = min(mind,dist);
            }
        }
    }
    return mind;
}

float3 voronoise(float2 p){
    float2 i = floor(p);
    float2 f = frac(p);
    
    float2 pt = 0.0;
    float2 res = 8.0;
    for(int x = -1;x <=1;x++){
        for(int y = -1; y <=1;y++){
            float2 n = float2(x,y);
            float2 np = hash22(n + i);
            float2 p = np + n - f;
            float l = length(p);
            if(l < res.x){
                res.y = res.x;
                res.x = l;
                pt = n + i;
            } else if(l < res.y){
                res.y = l;
            }
        }
    }
    res = sqrt(res);
    return float3(res.y - res.x, pt);
}

float4 voronoise(float3 p){
    float3 i = floor(p);
    float3 f = frac(p);
    
    float3 pt = 0.0;
    float2 res = 8.0;
    for(float x = -1;x <=1;x++){
        for(float y = -1; y <=1;y++){
            for(float z = -1; z <=1; z++){
                float3 n = float3(x,y,z);
                float3 np = hash3(n + i);
                float3 p = np + n - f;
                float l = length(p);
                if(l < res.x){
                   res.y = res.x;
                   res.x = l;
                   pt = n + i;
                } else if(l < res.y){
                   res.y = l;
                }
            }
        }
    }
    res = sqrt(res);
    return float4(res.y - res.x, pt);
}

//
// Noise Shader Library for Unity - https://github.com/keijiro/NoiseShader
//
// Original work (webgl-noise) Copyright (C) 2011 Ashima Arts.
// Translation and modification was made by Keijiro Takahashi.
//
// This shader is based on the webgl-noise GLSL shader. For further details
// of the original shader, please see the following description from the
// original source code.
//

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
//

float3 mod289(float3 x)
{
    return x - floor(x / 289.0) * 289.0;
}

float2 mod289(float2 x)
{
    return x - floor(x / 289.0) * 289.0;
}

float3 permute(float3 x)
{
    return mod289((x * 34.0 + 1.0) * x);
}

float3 taylorInvSqrt(float3 r)
{
    return 1.79284291400159 - 0.85373472095314 * r;
}

float snoise(float2 v)
{
    const float4 C = float4( 0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                             0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                            -0.577350269189626,  // -1.0 + 2.0 * C.x
                             0.024390243902439); // 1.0 / 41.0
    // First corner
    float2 i  = floor(v + dot(v, C.yy));
    float2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    float2 i1;
    i1.x = step(x0.y, x0.x);
    i1.y = 1.0 - i1.x;

    // x1 = x0 - i1  + 1.0 * C.xx;
    // x2 = x0 - 1.0 + 2.0 * C.xx;
    float2 x1 = x0 + C.xx - i1;
    float2 x2 = x0 + C.zz;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float3 p =
      permute(permute(i.y + float3(0.0, i1.y, 1.0))
                    + i.x + float3(0.0, i1.x, 1.0));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
    m = m * m;
    m = m * m;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;

    // Normalise gradients implicitly by scaling m
    m *= taylorInvSqrt(a0 * a0 + h * h);

    // Compute final noise value at P
    float3 g;
    g.x = a0.x * x0.x + h.x * x0.y;
    g.y = a0.y * x1.x + h.y * x1.y;
    g.z = a0.z * x2.x + h.z * x2.y;
    return 130.0 * dot(m, g);
}

float3 snoise_grad(float2 v)
{
    const float4 C = float4( 0.211324865405187,  // (3.0-sqrt(3.0))/6.0
                             0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
                            -0.577350269189626,  // -1.0 + 2.0 * C.x
                             0.024390243902439); // 1.0 / 41.0
    // First corner
    float2 i  = floor(v + dot(v, C.yy));
    float2 x0 = v -   i + dot(i, C.xx);

    // Other corners
    float2 i1;
    i1.x = step(x0.y, x0.x);
    i1.y = 1.0 - i1.x;

    // x1 = x0 - i1  + 1.0 * C.xx;
    // x2 = x0 - 1.0 + 2.0 * C.xx;
    float2 x1 = x0 + C.xx - i1;
    float2 x2 = x0 + C.zz;

    // Permutations
    i = mod289(i); // Avoid truncation effects in permutation
    float3 p =
      permute(permute(i.y + float3(0.0, i1.y, 1.0))
                    + i.x + float3(0.0, i1.x, 1.0));

    float3 m = max(0.5 - float3(dot(x0, x0), dot(x1, x1), dot(x2, x2)), 0.0);
    float3 m2 = m * m;
    float3 m3 = m2 * m;
    float3 m4 = m2 * m2;

    // Gradients: 41 points uniformly over a line, mapped onto a diamond.
    // The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)
    float3 x = 2.0 * frac(p * C.www) - 1.0;
    float3 h = abs(x) - 0.5;
    float3 ox = floor(x + 0.5);
    float3 a0 = x - ox;

    // Normalise gradients
    float3 norm = taylorInvSqrt(a0 * a0 + h * h);
    float2 g0 = float2(a0.x, h.x) * norm.x;
    float2 g1 = float2(a0.y, h.y) * norm.y;
    float2 g2 = float2(a0.z, h.z) * norm.z;

    // Compute noise and gradient at P
    float2 grad =
      -6.0 * m3.x * x0 * dot(x0, g0) + m4.x * g0 +
      -6.0 * m3.y * x1 * dot(x1, g1) + m4.y * g1 +
      -6.0 * m3.z * x2 * dot(x2, g2) + m4.z * g2;
    float3 px = float3(dot(x0, g0), dot(x1, g1), dot(x2, g2));
    return 130.0 * float3(grad, dot(m4, px));
}


#endif

