//
//  ARExperience.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.11.2021.
//

import SwiftUI
import SpriteKit

struct ARExperience: View {
    @Environment(\.presentationMode) var presentationMode
    
    @AppStorage("bestScore") var bestScore = 0
    @StateObject private var gameScene = BreakoutGame()
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
            
            VStack(alignment: .leading) {
                Text("Level: \(gameScene.level)")
                    .font((.system(size: 12, weight: .heavy)))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.top, 42)
                
                Text("Score: \(gameScene.score)")
                    .font((.system(size: 24, weight: .heavy)))
                    .foregroundColor(.white)
                    .padding(.leading)
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("close")
                }
                .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if gameScene.isGameOver {
                VStack {
                    Text("Game Over")
                        .font((.system(size: 42, weight: .heavy)))
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    if gameScene.score > bestScore {
                        Text("New Best Score!!!")
                            .font((.system(size:34, weight: .heavy)))
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        Text("\(gameScene.score)")
                            .font((.system(size:34, weight: .heavy)))
                            .foregroundColor(.white)
                            .padding(.leading)
                        }
                    
                    Text("Play Again")
                        .font((.system(size:24, weight: .heavy, design: .rounded)))
                        .foregroundColor(.white)
                        .padding(.leading)
                        .padding()
                        .onTapGesture {
                            if gameScene.score > bestScore {
                                bestScore = gameScene.score
                            }
                            
                            gameScene.isGameOver.toggle()
                            gameScene.makeBall()
                            gameScene.makeBricks()
                            gameScene.score = 0
                        }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct ARExperience_Previews: PreviewProvider {
    static var previews: some View {
        ARExperience()
    }
}
