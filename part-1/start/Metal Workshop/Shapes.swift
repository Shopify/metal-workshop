import Foundation
import MetalKit

struct Vertex {
	let position: vector_float4
	let color: vector_float4
}

struct InnefficientCircleUniform {}

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

struct InnefficientCircle: Shape {

	private var numSides: UInt16

	var vertices: [CGPoint]
	var indices: [UInt16]

	init(numSides: UInt16) {
	}

	static func verticesForCircle(numSides: UInt16) -> [CGPoint] {
	}

	func uniform() -> InnefficientCircleUniform {
		return InnefficientCircleUniform()
	}
}
