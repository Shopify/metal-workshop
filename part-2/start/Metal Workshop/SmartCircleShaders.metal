#include <metal_stdlib>
#include "Structs.metal"
#include "UtilHeader.metal"

using namespace metal;

vertex OutVertex smart_circle_vertex_main(constant InVertex *vertices [[buffer(0)]],
										  constant SmartCircleUniform *uniforms [[buffer(1)]],
										  ushort vid [[vertex_id]],
										  ushort iid [[instance_id]]) {

	SmartCircleUniform uniform = uniforms[iid];
	InVertex inVertex = vertices[vid];
	OutVertex outVertex;

	//shift OutVertex
	float2 clipOrigin = toClipFromWindow(uniform.windowOrigin, uniform.windowSize);
	outVertex.position = float4(inVertex.position[0] + clipOrigin[0],
								inVertex.position[1] + clipOrigin[1],
								inVertex.position[2],
								inVertex.position[3]);

	//set window origin and size
	outVertex.windowOrigin = uniform.windowOrigin;
	outVertex.windowSize = uniform.windowSize;

	//set colour
	outVertex.color = inVertex.color;

	return outVertex;
};

fragment float4 smart_circle_fragment_main(OutVertex outVertex [[stage_in]])
{
	//Metal has window coordinate system flipped from MacOS on Y axis
	float2 flippedWindowOrigin = float2(outVertex.windowOrigin[0],
										outVertex.windowSize[1] - outVertex.windowOrigin[1]);
}
