import Foundation
import Metal
import MetalKit

class CircleRenderer: Renderer {

	let device = MTLCreateSystemDefaultDevice()!

	//shape definition
	let vertexCount: Int = 6
	var indexCount: Int = 0
	var shapes = [InnefficientCircle]()

	//instanced rendering
	var indexBuffer: MTLBuffer?
	var vertexBuffer: MTLBuffer?
	var uniformBuffer: MTLBuffer?
	var instanceCount: Int { return self.shapes.count }

	//shader functions
	var vertexFunction: MTLFunction?
	var fragmentFunction: MTLFunction?
	var vertexFunctionName: String { return "circle_vertex_main" }
	var fragmentFunctionName: String { return "circle_fragment_main" }

	func configure() {

		guard let circle = self.shapes.first else { return }
		if self.vertexBuffer != nil { return }

		//set the vertex buffer once for instance rendering
		let verticies = circle.mtlVertices()
		let vb = self.device.makeBuffer(bytes: verticies, length: verticies.count * MemoryLayout<Vertex>.size, options: MTLResourceOptions())
		self.vertexBuffer = vb

		//set the index buffer once
		let indices = circle.indices
		self.indexCount = indices.count
		self.indexBuffer = self.device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: MTLResourceOptions())

		if let library = self.device.newDefaultLibrary() {
			self.vertexFunction = library.makeFunction(name: self.vertexFunctionName)
			self.fragmentFunction = library.makeFunction(name: self.fragmentFunctionName)
		}
	}

	func drawShape(clipPosition: CGPoint) {
		let newCircle = InnefficientCircle(numSides: UInt16(self.vertexCount), clipPosition: clipPosition)
		self.shapes.append(newCircle)
		self.configure()
		self.updateUniformBuffer()
	}

	func circleUniforms() -> [InnefficientCircleUniform] {
		return self.shapes.map { $0.uniform(windowSize: CGSize.zero) }
	}

	func updateUniformBuffer() {
		let uniforms = self.circleUniforms()
		self.uniformBuffer = self.device.makeBuffer(bytes: uniforms, length: uniforms.count * 64, options: MTLResourceOptions())
	}
}
