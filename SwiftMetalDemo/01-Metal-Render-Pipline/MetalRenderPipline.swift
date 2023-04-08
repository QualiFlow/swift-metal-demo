//
//  MetalRenderPipline.swift
//  SwiftMetalDemo
//
//  Created by Kaifuny on 2023/4/8.
//
import SwiftUI
import MetalKit

struct MetalRenderPiplineView: UIViewRepresentable {

  func makeCoordinator() -> Renderer {
    Renderer(self)
  }
  
  func makeUIView(context: UIViewRepresentableContext<MetalRenderPiplineView>) -> MTKView {
    let mtkView = MTKView()
    mtkView.delegate = context.coordinator
    mtkView.preferredFramesPerSecond = 60
    mtkView.enableSetNeedsDisplay = true
    
    if let metalDevice = MTLCreateSystemDefaultDevice() {
      mtkView.device = metalDevice
    }
    
    mtkView.framebufferOnly = false
    mtkView.drawableSize = mtkView.frame.size
    
    return mtkView
  }

  func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<MetalRenderPiplineView>) {
  }

}
