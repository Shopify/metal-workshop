#include <metal_stdlib>
#include "Structs.metal"

using namespace metal;

vertex InVertex circle_vertex_main(constant InVertex *vertices [[buffer(0)]],
								 constant InnefficientCircleUniform *uniforms [[buffer(1)]],
								 ushort vid [[vertex_id]],
								 ushort iid [[instance_id]]) {

	InVertex inVertex = vertices[vid];
	InVertex outVertex;

	float2 clipOrigin = uniforms[iid].clipOrigin;

	outVertex.position = float4(inVertex.position[0] + clipOrigin[0],
								inVertex.position[1] + clipOrigin[1],
								inVertex.position[2],
								inVertex.position[3]);
	outVertex.color    = inVertex.color;

	return outVertex;
};

fragment half4 circle_fragment_main(InVertex inFrag [[stage_in]])
{
	return half4(inFrag.color);
};
