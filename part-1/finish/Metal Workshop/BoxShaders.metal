#include <metal_stdlib>
#include "Structs.metal"
#include "UtilHeader.metal"

using namespace metal;

vertex InVertex box_vertex_main(constant InVertex *vertices [[buffer(0)]],
									  constant BoxUniform *uniforms [[buffer(1)]],
									  ushort vid [[vertex_id]],
									  ushort iid [[instance_id]]) {
	return vertices[vid];
};

fragment half4 box_fragment_main(OutVertex outVertex [[stage_in]])
{
	return half4(outVertex.color);
}
