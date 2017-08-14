import Foundation
import MetalKit

struct Vertex {
	let position: vector_float4
	let color: vector_float4
}

struct SmartCircleUniform {
	let windowSize: float2
	let windowOrigin: float2
}

protocol Shape {
	var vertices: [CGPoint] { get }
	var indices: [UInt16] { get }

	func mtlVertices() -> [Vertex]
}

extension Shape {
	func mtlVertices() -> [Vertex] {
		return self.vertices.map {
			return Vertex(
				position: [Float($0.x), Float($0.y), 0, 1],
				color: [0, 1, 0, 1])
		}
	}
}

struct SmartCircle: Shape {

	var windowOrigin: CGPoint
	var alpha: Float

	public let vertices: [CGPoint] = [
		CGPoint(x: -0.5, y: 0.5),
		CGPoint(x: -0.5, y: -0.5),
		CGPoint(x: 0.5,  y: -0.5),
		CGPoint(x: 0.5,  y: 0.5),
	]

	public let indices: [UInt16] = [0, 1, 3, 2]

	func uniform(windowSize: CGSize) -> SmartCircleUniform {
		return SmartCircleUniform(
			windowSize: windowSize.toFloat2(),
			windowOrigin: self.windowOrigin.toFloat2())
	}
}
