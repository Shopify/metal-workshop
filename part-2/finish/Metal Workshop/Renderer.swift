import Foundation
import Metal

protocol Renderer {
	var vertexFunction: MTLFunction? { get }
	var fragmentFunction: MTLFunction? { get }
	var indexBuffer: MTLBuffer? { get }
	var vertexBuffer: MTLBuffer? { get }
	var uniformBuffer: MTLBuffer? { get }
	var instanceCount: Int { get }
}
