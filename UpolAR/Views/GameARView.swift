//
//  ARExperience.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.11.2021.
//

import SwiftUI
import RealityKit

struct GameARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var color: UIColor = .red
    @State var position: Float? = nil
    @State var lastPosition: Float = 0.0
    @State var isPressedStart: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            BreakoutGameAR(position: $position, isPressedStart: $isPressedStart).ignoresSafeArea()
            
            buttons
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                    .onChanged ({ (value) in
                        if value.location.y > 280 {
                            position = getPosition(value: value)
            }
                    })
                    .onEnded({ _ in
            lastPosition = position ?? 0.0
        }))
        
    }
    
    // MARK: Functions
    func getPosition(value: DragGesture.Value) -> Float {
        print("DEBUG: start: \(value.startLocation.x) current: \(value.location.x)")
        
        var distance = Float(value.location.x - value.startLocation.x)
        let boundaries: [Float] = [Float(UIScreen.main.bounds.width) / -4,
                                   Float(UIScreen.main.bounds.width) / 4]
        
        if distance < boundaries[0] {
            distance = boundaries[0]
        } else if distance > boundaries[1] {
            distance = boundaries[1]
        }
        
        distance = distance + boundaries[1]
        
        let xPercentage = Float(distance / (boundaries[1]*2))
        print("DEBUG: xPercentage: \(xPercentage)")
        
        let totalPosition = (xPercentage * 0.40) - 0.20 + lastPosition
        
        if totalPosition > 0.09 {
            return 0.09
        } else if totalPosition < -0.09 {
            return -0.09
        } else {
            return totalPosition
        }
        
    }
}

extension GameARView {
    // MARK: Buttons
    var buttons: some View {
            HStack {
                Button {
                    collisionSubscribing = nil
                    revealSubscribing = nil
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Color.red
                                .cornerRadius(10)
                        )
                        .padding()
                }
                
                Spacer()
                Button {
                    isPressedStart = true
                } label: {
                    Text("Start")
                        .foregroundColor(Color("AccentColor"))
                        .padding()
                        .padding(.horizontal)
                        .background(
                            Color.white
                                .cornerRadius(10)
                        )
                        .padding()
                }
            }
    }
}

struct ARExperience_Previews: PreviewProvider {
    static var previews: some View {
        GameARView()
    }
}
