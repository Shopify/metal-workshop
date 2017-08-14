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
		self.numSides = numSides
		self.vertices = InnefficientCircle.verticesForCircle(numSides: numSides)

		var vertexCounter: UInt16 = 0
		var tmpIndices: [UInt16] = []
		while vertexCounter < numSides {
			tmpIndices.append(0)
			tmpIndices.append(vertexCounter)
			tmpIndices.append(vertexCounter + 1)
			vertexCounter += 1
		}
		//last side
		tmpIndices.append(vertexCounter)
		tmpIndices.append(0)
		tmpIndices.append(1)

		self.indices = tmpIndices
	}

	static func verticesForCircle(numSides: UInt16) -> [CGPoint] {
		let centrePoint = CGPoint.zero
		let rightPoint = CGPoint(x: 0.25, y: 0)
		var points: [CGPoint] = [centrePoint, rightPoint]

		let twoPi: CGFloat = CGFloat(2 * Double.pi)
		let dTheta = twoPi/CGFloat(numSides)
		for vertex in stride(from: 1, to: numSides, by: 1) {
			let rotationAngle = dTheta * CGFloat(vertex)
			points.append(rightPoint.rotate(byRadians: rotationAngle))
		}

		return points
	}

	func uniform() -> InnefficientCircleUniform {
		return InnefficientCircleUniform()
	}
}
