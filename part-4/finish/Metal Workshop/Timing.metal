#include <metal_stdlib>
#include "TimingHeader.metal"
using namespace metal;

__constant float4 timingFunctionControlPoints = float4(0, 0.419999, 0.579999, 1);

float valueForTimestep(float timeStep) {
    float4 timingFunction = float4((pow(1 - timeStep, 3)),
                                   (3*pow(1 - timeStep, 2)*timeStep),
                                   (3*(1-timeStep)*pow(timeStep, 2)),
                                   (pow(timeStep, 3)));

    return dot(timingFunctionControlPoints, timingFunction);
}
