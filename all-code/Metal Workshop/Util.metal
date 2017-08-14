#include <metal_stdlib>
#include "UtilHeader.metal"
using namespace metal;

float distance_away(float2 p1, float2 p2) {
	return sqrt((p2[0] - p1[0]) * (p2[0] - p1[0]) + ((p2[1] - p1[1]) * (p2[1] - p1[1])));
}

float2 toClipFromWindow(float2 windowPosition, float2 windowSize) {
	float2 flipped = float2(windowPosition[0], windowSize[1] - windowPosition[1]);
	return float2(-1 + (2*flipped[0]/windowSize[0]), 1 - (2*flipped[1]/windowSize[1]));
}
