//
//  ARNavigator.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 05.12.2021.
//


import SwiftUI
import RealityKit

struct ARNavigator : View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            ARViewContainer().edgesIgnoringSafeArea(.all)

            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("close")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .padding()
            }

        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Navigator.loadBox()
        let bytAnchor = try! Navigator.loadByt()
        
        // bytAnchor.bottomSide?.isEnabled = false
       
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        arView.scene.anchors.append(bytAnchor)
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ARNavigator_Previews : PreviewProvider {
    static var previews: some View {
        ARNavigator()
    }
}
#endif
