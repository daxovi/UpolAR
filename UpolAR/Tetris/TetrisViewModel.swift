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
    var nextBoard: [[Int]]
    var position: [Int]
    let startPosition: [Int]
    var brick: BrickModel?
    
    init(rows: Int, columns: Int) {
        board = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        nextBoard = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        position = [0, columns/2 - 1]
        startPosition = [0, columns/2 - 1]
        
        stop()
    }
    
    func step() {
        if self.brick != nil {
            fall()
        } else {
            addBrick()
        }
    }
    
    func getRandomBrick() -> BrickModel {
        let bricks: [BrickType] = [.corner, .el, .square, .line]
        
        let randomIndex = Int.random(in: 0..<bricks.count)
        let randomBrick = bricks[randomIndex]
        let randomBrickModel = BrickModel(type: randomBrick)
        
        self.brick = randomBrickModel
        return randomBrickModel
    }
    
    func addBrick(write: Bool = true) {
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
               // clearNextBoard()
            }
        } else {
            nextBoard = Array(board)
            position = Array(startPosition)
            self.brick = nil
            writeBoard()
            player.upstream.connect().cancel()
        }
        
    }
    
    func clearNextBoard() {
        for (rowIndex, _) in nextBoard.enumerated() {
            for (columnIndex, value) in nextBoard[rowIndex].enumerated() {
                if value == 1 {
                    nextBoard[rowIndex][columnIndex] = 0
                }
            }
        }
    }
    
    func writeBoard() {
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
    
    func fall() {
        if isFallValid() {
            if self.brick != nil {
                self.position[0] = self.position[0] + 1
                addBrick()
            }
        } else {
            endMove()
        }
    }
    
    func endMove() {
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
    
    func isFallValid() -> Bool {
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
        if isMoveValid(horizontalMove: horizontalMove) {
            self.position[1] = self.position[1] + horizontalMove.rawValue
            addBrick()
        }
    }
    
    func isMoveValid(horizontalMove: Move) -> Bool {
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
    
    func isMoveOnBoard(horizontalMove: Move) -> Bool {
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
    
    
    
    func isRotateOnBoard() -> Bool {
        if let mesh = brick?.mesh {
            if position[1] + mesh.count <= nextBoard[0].count {
                return true
            }
        }
        return false
    }
    
    func isNextBoardValid() -> Bool {
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
    
    func isRotateValid() -> Bool {
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
        
        stop()
    }
    
    func start() {
        self.player = Timer.publish(every: 1.0, tolerance: 0.1, on: .main, in: .common).autoconnect()
    }
    
    func stop() {
        self.player.upstream.connect().cancel()
    }
    
    enum Move: Int {
        case right = 1
        case left = -1
        case none = 0
    }
}
