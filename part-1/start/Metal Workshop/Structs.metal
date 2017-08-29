#include <metal_stdlib>
using namespace metal;

struct InVertex
{
	float4  position [[position]];
	float4  color;
};

struct OutVertex {
	float4 position [[position]];
	float4 color;
	float2 windowOrigin;
	float2 windowSize;
};

struct BoxUniform {
	float2 windowSize;
	float2 windowOrigin;
};

