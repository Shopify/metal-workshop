import Foundation
import MetalKit

struct Vertex {
	let position: vector_float4
	let color: vector_float4
}

struct BoxUniform {}

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

struct Box: Shape {

	var windowOrigin: CGPoint
	var alpha: Float

	public let vertices: [CGPoint] =

	public let indices: [UInt16] =

	func uniform(windowSize: CGSize) -> BoxUniform {
		return BoxUniform()
	}
}
