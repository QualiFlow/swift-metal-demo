//
//  Renderer.swift
//
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
  
  var parent: MetalRenderPiplineView
  var metalDevice: MTLDevice!
  var metalCommandQueue: MTLCommandQueue!
  let pipelineState: MTLRenderPipelineState
  let vertexBuffer: MTLBuffer
  
  init(_ parent: MetalRenderPiplineView) {
    
    self.parent = parent
    if let metalDevice = MTLCreateSystemDefaultDevice() {
      self.metalDevice = metalDevice
    }
    self.metalCommandQueue = metalDevice.makeCommandQueue()
    
    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    let library = metalDevice.makeDefaultLibrary()
    pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
    pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
    pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
    
    do {
      try pipelineState = metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch {
      fatalError()
    }
    
    let vertices = [
      Vertex(position: [-0.5, -0.5], color: [1, 0, 0, 1]),
      Vertex(position: [0.5, -0.5], color: [0, 1, 0, 1]),
      Vertex(position: [0, 0.5], color: [0, 0, 1, 1])
    ]
    vertexBuffer = metalDevice.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride, options: [])!
    super.init()
  }
  
  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    
  }
  
  func draw(in view: MTKView) {
    
    guard let drawable = view.currentDrawable else {
      return
    }
    
    let commandBuffer = metalCommandQueue.makeCommandBuffer()
    
    let renderPassDescriptor = view.currentRenderPassDescriptor
    renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(1, 1, 1, 1.0)
    renderPassDescriptor?.colorAttachments[0].loadAction = .clear
    renderPassDescriptor?.colorAttachments[0].storeAction = .store
    
    let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
    
    renderEncoder?.setRenderPipelineState(pipelineState)
    renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
    
    renderEncoder?.endEncoding()
    
    commandBuffer?.present(drawable)
    commandBuffer?.commit()
  }
}
