#include <metal_stdlib>
#include "Structs.metal"

using namespace metal;

vertex InVertex circle_vertex_main(constant InVertex *vertices [[buffer(0)]],
								 constant InnefficientCircleUniform *uniforms [[buffer(1)]],
								 ushort vid [[vertex_id]],
								 ushort iid [[instance_id]]) {

	InVertex inVertex = vertices[vid];
	return inVertex;
};

fragment half4 circle_fragment_main(InVertex inFrag [[stage_in]])
{
	return half4(inFrag.color);
};
