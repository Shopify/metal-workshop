import Foundation
import MetalKit

struct Vertex {
	let position: vector_float4
	let color: vector_float4
}

struct InnefficientCircleUniform {
	let clipPosition: float2
}

struct SmartCircleUniform {
	let windowSize: float2
	let windowOrigin: float2
}

struct PulsingCircleUniform {
	let windowSize: float2
	let windowOrigin: float2
	let animationTime: float_t
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

struct PulsingCircle: Shape {

	static let ANIMATION_DURATION: TimeInterval = 1

	var windowOrigin: CGPoint
	var animationTime: TimeInterval

	public let vertices: [CGPoint] = [
		CGPoint(x: -0.5, y: 0.5),
		CGPoint(x: -0.5, y: -0.5),
		CGPoint(x: 0.5,  y: -0.5),
		CGPoint(x: 0.5,  y: 0.5),
		]

	public let indices: [UInt16] =  [0, 1, 3, 2]

	init(windowOrigin: CGPoint,
	     animationTime: TimeInterval = 0) {
			self.windowOrigin = windowOrigin
			self.animationTime = animationTime
	}

	func uniform(windowSize: CGSize) -> PulsingCircleUniform {
		return PulsingCircleUniform(
			windowSize: windowSize.toFloat2(),
			windowOrigin: self.windowOrigin.toFloat2(),
			animationTime: Float(self.animationTime))
	}

	mutating func add(timestep: TimeInterval) {
		var newTime = self.animationTime + timestep
		if newTime > 2 * Double.pi {
			newTime = 0
		}
		self.animationTime = newTime
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

struct InnefficientCircle: Shape {

	var clipPosition: CGPoint
	private var numSides: UInt16

	var vertices: [CGPoint]
	var indices: [UInt16]

	init(numSides: UInt16, clipPosition: CGPoint) {
		self.clipPosition = clipPosition
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

	func uniform(windowSize: CGSize) -> InnefficientCircleUniform {
		return InnefficientCircleUniform(clipPosition: self.clipPosition.toFloat2())
	}
}
