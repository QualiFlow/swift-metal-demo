//
//  ContentView.swift
//  SwiftMetalDemo
//
//  Created by Kaifuny on 2023/4/8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalRenderPiplineView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
