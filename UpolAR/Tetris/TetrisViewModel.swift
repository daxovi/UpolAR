//
//  TetrisViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.06.2023.
//

import SwiftUI

class TetrisViewModel: ViewModel {
    @Published var player = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
    @Published var board = [[Int]](repeating: [Int](repeating: 0, count: 15), count: 20)
    @Published var score = 0 {
        didSet {
            if oldValue != score {
                let speed = Double(1.0 - (Double(score) / 10.0))
                if speed > 0.2 {
                    player = Timer.publish(every: speed, tolerance: 0.1, on: .main, in: .common).autoconnect()
                }
            }
        }
    }
    @Published var finalScore = 0
    @Published var gameState: GameState = .ready
    
    static let shared = TetrisViewModel()
    let tetrisGame: TetrisGame
    
    override init() {
        self.tetrisGame = TetrisGame(rows: 20, columns: 15)
        super.init()
    }
    
    func renderGame() {
        tetrisGame.step()
        self.board = Array(tetrisGame.board)
        self.score = tetrisGame.score
        self.finalScore = tetrisGame.finalScore
        self.gameState = tetrisGame.gameState
    }
    
    func gestureRecognizer(value: DragGesture.Value) {
        if value.translation.width < -50 {
            tetrisGame.horizontalMove(.left)
            self.board = Array(tetrisGame.board)
        }
        if value.translation.width > 50 {
            tetrisGame.horizontalMove(.right)
            self.board = Array(tetrisGame.board)
        }
        if value.translation.height < -50 {
            tetrisGame.rotate()
            self.board = Array(tetrisGame.board)
        }
        if value.translation.height > 50 {
            renderGame()
            self.board = Array(tetrisGame.board)
        }
    }
    
    func start() {
        tetrisGame.gameState = .play
        self.player = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
        renderGame()
    }
}
