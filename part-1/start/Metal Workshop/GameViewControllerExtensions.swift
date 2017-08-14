import Foundation
import MetalKit

extension GameViewController {

	func pipelineFor(renderer: Renderer) -> MTLRenderPipelineState? {
		if let vertexFunc = renderer.vertexFunction,
			let fragmentFunc = renderer.fragmentFunction {

			let pipelineDescriptor = MTLRenderPipelineDescriptor()
			pipelineDescriptor.vertexFunction = vertexFunc
			pipelineDescriptor.fragmentFunction = fragmentFunc
			pipelineDescriptor.colorAttachments[0].pixelFormat = (self.view as! MTKView).colorPixelFormat

			setupMultiAliasing(descriptor: pipelineDescriptor)

			do {
				return try self.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
			} catch(_) { }
		}
		return nil
	}

	fileprivate func setupMultiAliasing(descriptor: MTLRenderPipelineDescriptor) {
		self.setupDescriptorForAliasing(pipelineDescriptor: descriptor)
	}

	fileprivate func setupDescriptorForAliasing(pipelineDescriptor: MTLRenderPipelineDescriptor) {
		pipelineDescriptor.sampleCount = 4
		pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
		pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.sourceAlpha
		pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.sourceAlpha
		pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.oneMinusSourceAlpha
		pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.oneMinusSourceAlpha
	}

	fileprivate func createMultiSampleDescriptor() -> MTLTextureDescriptor {
		let descriptor = MTLTextureDescriptor()
		descriptor.textureType = MTLTextureType.type2DMultisample
		descriptor.width = Int(self.view.frame.width)
		descriptor.height = Int(self.view.frame.height)
		descriptor.sampleCount = 4
		descriptor.pixelFormat = .bgra8Unorm
		return descriptor
	}
}
