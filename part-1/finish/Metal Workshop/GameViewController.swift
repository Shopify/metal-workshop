import Cocoa
import MetalKit

class GameViewController: NSViewController, MTKViewDelegate {
    
	var device: MTLDevice! = nil
	var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil

	//renderers
	let circleRenderer = BoxRenderer()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.device = MTLCreateSystemDefaultDevice()
		self.commandQueue = device.makeCommandQueue()
		self.commandQueue.label = "main command queue"
        guard device != nil else { // Fallback to a blank NSView, an application could also fallback to OpenGL here.
            print("Metal is not supported on this device")
            self.view = NSView(frame: self.view.frame)
            return
        }

        // setup view properties
        let view = self.view as! MTKView
        view.delegate = self
        view.device = device
        view.sampleCount = 4
		view.preferredFramesPerSecond = 30

		//add circles to draw
		let position1 = CGPoint(x: 500, y: 500)
		self.circleRenderer.drawShape(windowPosition: position1)
	}

    func update() {
        //this is where buffers update
    }
    
    func draw(in view: MTKView) {
        self.update()
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        commandBuffer.label = "Frame command buffer"
        
        if let renderPassDescriptor = view.currentRenderPassDescriptor, let currentDrawable = view.currentDrawable {
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder.label = "render encoder"

			let texture: MTLTexture? = currentDrawable.texture
			renderPassDescriptor.colorAttachments[0].resolveTexture = texture

			//circles
			let pipeline = self.pipelineFor(renderer: self.circleRenderer)!
			renderEncoder.setRenderPipelineState(pipeline)
			renderEncoder.setVertexBuffer(self.circleRenderer.vertexBuffer, offset: 0, at: 0)
			renderEncoder.setVertexBuffer(self.circleRenderer.uniformBuffer, offset: 0, at: 1)
			renderEncoder.drawIndexedPrimitives(type: .triangleStrip,
			                              indexCount: self.circleRenderer.indexCount,
			                              indexType: .uint16,
			                              indexBuffer: self.circleRenderer.indexBuffer!,
			                              indexBufferOffset: 0,
			                              instanceCount: self.circleRenderer.instanceCount)

            renderEncoder.popDebugGroup()
            renderEncoder.endEncoding()
            
            commandBuffer.present(currentDrawable)
        }

        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
		self.circleRenderer.windowSize = size
    }
}
