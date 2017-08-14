#include <metal_stdlib>
#include "Structs.metal"
#include "UtilHeader.metal"

using namespace metal;

vertex OutVertex pulsing_circle_vertex_main(constant InVertex *vertices [[buffer(0)]],
										  constant PulsingCircleUniform *uniforms [[buffer(1)]],
										  ushort vid [[vertex_id]],
										  ushort iid [[instance_id]]) {

	PulsingCircleUniform uniform = uniforms[iid];
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
	float alpha = fabs(sin(uniform.animationTime));
	outVertex.color = float4(inVertex.color[0],
							 inVertex.color[1],
							 inVertex.color[2],
							 alpha);

	return outVertex;
};

fragment half4 pulsing_circle_fragment_main(OutVertex outVertex [[stage_in]])
{
	//calculate distance from origin
	float2 flippedWindowOrigin = float2(outVertex.windowOrigin[0],
										outVertex.windowSize[1] - outVertex.windowOrigin[1]);

	float distance = distance_away(
								   flippedWindowOrigin,
								   float2(outVertex.position[0], outVertex.position[1])
								   );

	//get circle radius
	float maxRadius = min(outVertex.windowSize[0], outVertex.windowSize[1])/4;
	float circleRadius = maxRadius - (outVertex.color[3] * maxRadius);
	if (distance < circleRadius && distance > (circleRadius - 2)) {
		return half4(outVertex.color);
	} else {
		return half4(0);
	}
}
