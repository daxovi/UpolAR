//
//  TetrisViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.06.2023.
//

import SwiftUI

class TetrisViewModel: ObservableObject {
    
    @Published var player = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
    @Published var board: [[Int]]
    @Published var showingAlert: Bool
    @Published var score: Int
    @Published var finalScore: Int
    @Published var gameState: GameState
    
    private var nextBoard: [[Int]]
    private var position: [Int]
    private let startPosition: [Int]
    private var brick: BrickModel?
    
    init(rows: Int, columns: Int) {
        self.score = 0
        self.finalScore = 0
        self.showingAlert = false
        self.board = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        self.nextBoard = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        self.position = [0, columns/2 - 1]
        self.startPosition = [0, columns/2 - 1]
        self.gameState = .ready
        
        /*
        board[0][0] = 1
        board[0][board[0].count - 1] = 1
        board[board.count - 1][0] = 1
        board[board.count - 1][board[0].count - 1] = 1
          */
    }
    
    func renderGame() {
        switch gameState {
            
        case .ready:
            self.score = 0
            print("Press Start")
            
        case .play:
            self.eraseFullRow()
            if self.brick != nil {
                self.fall()
            } else {
                self.addBrick()
            }
            finalScore = score
            
        case .end:
            print("Game Over")
            nextBoard = [[Int]](repeating: [Int](repeating: 0, count: nextBoard[0].count), count: nextBoard.count)
            board = [[Int]](repeating: [Int](repeating: 0, count: board[0].count), count: board.count)
            position = Array(startPosition)
            self.brick = nil
            writeBoard()
            
            score = 0
            player.upstream.connect().cancel()
        }
    }
    
    private func levelUp() {
        score = score + 1
        let speed = Double(1.0 - (Double(score) / 10.0))
        print("DEBU: new speed: \(speed)")
        if speed > 0.2 {
            player = Timer.publish(every: speed, tolerance: 0.1, on: .main, in: .common).autoconnect()
        }
    }
    
    private func eraseFullRow() {
        for (rowIndex, row) in board.enumerated() {
            
            var fullRow = true
            
            for (columnIndex, value) in row.enumerated() {
                if value == 2 {
                    fullRow = fullRow && true
                } else {
                    fullRow = false
                }
            }
            
            if fullRow {
                board.remove(at: rowIndex)
                levelUp()
                let newRow = [Int](repeating: 0, count: row.count)
                board.insert(newRow, at: 0)
            }
        }
    }
    
    private func getRandomBrick() -> BrickModel {
        let bricks: [BrickType] = [.corner, .el, .square, .line]
        
        let randomIndex = Int.random(in: 0..<bricks.count)
        let randomBrick = bricks[randomIndex]
        let randomBrickModel = BrickModel(type: randomBrick)
        
        self.brick = randomBrickModel
        return randomBrickModel
    }
    
    private func addBrick(write: Bool = true) {
        clearNextBoard()
        let brick = self.brick ?? getRandomBrick()
        
        for rowIndex in 0..<brick.mesh.count {
            for columnIndex in 0..<brick.mesh[rowIndex].count {
                
                if brick.mesh[rowIndex][columnIndex] == 1 {
                    nextBoard[rowIndex + position[0]][columnIndex + position[1]] = brick.mesh[rowIndex][columnIndex]
                }
            }
        }
        if isNextBoardValid() {
            if write {
                writeBoard()
            }
        } else {
            gameState = .end
        }
        
    }
    
    private func clearNextBoard() {
        for (rowIndex, _) in nextBoard.enumerated() {
            for (columnIndex, value) in nextBoard[rowIndex].enumerated() {
                if value == 1 {
                    nextBoard[rowIndex][columnIndex] = 0
                }
            }
        }
    }
    
    private func writeBoard() {
        if isNextBoardValid() {
            for (rowIndex, _) in nextBoard.enumerated() {
                for (columnIndex, value) in nextBoard[rowIndex].enumerated() {
                    if board[rowIndex][columnIndex] != 2 {
                        board[rowIndex][columnIndex] = value
                    }
                }
            }
        } else {
            
        }
    }
    
    private func fall() {
        if isFallValid() {
            if self.brick != nil {
                self.position[0] = self.position[0] + 1
                addBrick()
            }
        } else {
            endMove()
        }
    }
    
    private func endMove() {
        self.brick = nil
        self.position = self.startPosition
        
        for rowIndex in (0..<board.count).reversed() {
            for columnIndex in (0..<board[rowIndex].count).reversed() {
                if board[rowIndex][columnIndex] == 1 {
                    board[rowIndex][columnIndex] = 2
                }
            }
        }
    }
    
    private func isFallValid() -> Bool {
        var valid = true
        
        for rowIndex in (0..<board.count).reversed() {
            for columnIndex in (0..<board[rowIndex].count).reversed() {
                if board[rowIndex][columnIndex] == 1 {
                    if rowIndex + 1 < board.count &&
                        (board[rowIndex + 1][columnIndex] < 2)
                    {
                        valid = valid && true
                    } else {
                        valid = false
                        return valid
                    }
                }
            }
        }
        return valid
    }
    
    func horizontalMove(horizontalMove: Move) {
        print("DEBUG: horizontal move")
        if isMoveValid(horizontalMove: horizontalMove) {
            self.position[1] = self.position[1] + horizontalMove.rawValue
            addBrick()
        }
    }
    
    private func isMoveValid(horizontalMove: Move) -> Bool {
        var valid = true
        
        if isMoveOnBoard(horizontalMove: horizontalMove) && self.brick != nil {
              for rowIndex in (0..<board.count) {
                  for columnIndex in (0..<board[rowIndex].count) {
                      if board[rowIndex][columnIndex] == 1 {
                          if board[rowIndex][columnIndex + horizontalMove.rawValue] < 2 {
                              valid = valid && true
                          } else {
                              valid = false
                              return valid
                          }
                      }
                  }
              }
        } else {
            valid = false
        }
        return valid
    }
    
    private func isMoveOnBoard(horizontalMove: Move) -> Bool {
        var valid = true
        
        for rowIndex in (0..<board.count).reversed() {
            for columnIndex in (0..<board[rowIndex].count).reversed() {
                if board[rowIndex][columnIndex] == 1 {
                    
                    if columnIndex + horizontalMove.rawValue >= 0 && columnIndex + horizontalMove.rawValue < board[rowIndex].count {
                        valid = valid && true
                    } else {
                        valid = false
                        return valid
                    }
                }
            }
        }
        return valid
    }
    
    
    
    private func isRotateOnBoard() -> Bool {
        if let mesh = brick?.mesh {
            if position[1] + mesh.count <= nextBoard[0].count {
                return true
            }
        }
        return false
    }
    
    private func isNextBoardValid() -> Bool {
        var valid = true
        
        for (rowIndex, _) in nextBoard.enumerated() {
            for (columnIndex, value) in nextBoard[rowIndex].enumerated() {
                if value == 1 &&
                    board[rowIndex][columnIndex] == 2
                {
                    valid = false
                    return valid
                }
            }
        }
        return valid
    }
    
    private func isRotateValid() -> Bool {
        if isRotateOnBoard() {
            brick?.rotate()
            addBrick(write: false)
            if isNextBoardValid() {
                print("DEBUG: isNextBoardValid = true")
                clearNextBoard()
                brick?.rotate(clockwise: false)
                addBrick(write: false)
                return true
            } else {
                print("DEBUG: isNextBoardValid = false")
                clearNextBoard()
                brick?.rotate(clockwise: false)
                addBrick(write: false)
            }
        }
        return false
    }
    
    func rotate() {
        if isRotateValid() {
            brick?.rotate()
            addBrick()
        }

    }
    
    func restart() {
        self.board = [[Int]](repeating: [Int](repeating: 0, count: board[0].count), count: board.count)
        self.nextBoard = [[Int]](repeating: [Int](repeating: 0, count: board[0].count), count: board.count)
        self.position = [0, board[0].count/2 - 1]
        self.brick = nil
        self.score = 0
        self.gameState = .ready
    }
    
    func start() {
        self.gameState = .play
        self.player = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
    }
    
    func showAlert() {
        self.showingAlert = true
    }
    
    enum Move: Int {
        case right = 1
        case left = -1
        case none = 0
    }
}

enum GameState {
    case ready, play, end
}
