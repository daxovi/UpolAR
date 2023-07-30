//
//  TetrisGame.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 29.07.2023.
//

import Foundation

class TetrisGame {
    var board: [[Int]]
    var score: Int
    var finalScore: Int
    var gameState: GameState
    
    private var position: [Int]
    private var startPosition: [Int]
    private var brick: BrickModel?
    private let rules: TetrisRules
    
    init(rows: Int, columns: Int) {
        self.board = [[Int]](repeating: [Int](repeating: 0, count: columns), count: rows)
        self.score = 0
        self.finalScore = 0
        self.gameState = .ready
        self.position = [-1, columns/2 - 1]
        self.startPosition = [-1, columns/2 - 1]
        self.rules = TetrisRules(rows: rows, columns: columns)
    }
    
    func step() {
        if gameState == .play {
            if self.brick != nil {
                move()
            } else {
                checkFullRow()
                self.brick = getRandomBrick()
                position = Array(startPosition)
                if rules.isgameOver(board: board) {
                    gameOver()
                }
            }
        }
    }
    
    private func move() {
        // kontrola moznosti pohybu dolu
        if (rules.isMoveValid(board: self.board)) {
            clearBrick()
            position = [position[0] + 1, position[1]]
            writeBrick()
        } else {
            bakeBrick()
            self.brick = nil
        }
    }
    
    private func bakeBrick() {
        for rowIndex in (0..<board.count) {
            for colIndex in (0..<board[0].count) {
                if board[rowIndex][colIndex] == 1 {
                    board[rowIndex][colIndex] = 2
                }
            }
        }
    }
    
    private func clearBrick() {
        for (rowIndex, row) in board.enumerated() {
            for (colIndex, value) in row.enumerated() {
                // pokud je hodnota rovna 1, změníme ji na 0
                if value == 1 {
                    board[rowIndex][colIndex] = 0
                }
            }
        }
    }
    
    private func writeBrick() {
        guard let brick = self.brick else { return }
        for rowIndex in 0..<brick.mesh.count {
            for columnIndex in 0..<brick.mesh[rowIndex].count {
                if brick.mesh[rowIndex][columnIndex] == 1 {
                    board[rowIndex + position[0]][columnIndex + position[1]] = brick.mesh[rowIndex][columnIndex]
                }
            }
        }
    }
    
    private func getRandomBrick() -> BrickModel {
        let bricks: [BrickType] = [.corner, .el, .square, .line, .jee, .tshirt, .zet]
        let randomIndex = Int.random(in: 0..<bricks.count)
        let randomBrick = bricks[randomIndex]
        let randomBrickModel = BrickModel(type: randomBrick)
        self.brick = randomBrickModel
        return randomBrickModel
    }
    
    func horizontalMove(_ move: Move) {
        if position[0] > -1 {
            if (rules.isHorizontalMoveValid(board: self.board, move: move)) {
                self.position = [position[0], position[1] + move.rawValue]
                clearBrick()
                writeBrick()
            }
        }
    }
    
    func rotate() {
        guard let brick = self.brick else { return }
        if position[0] > -1 {
            if rules.isRotationValid(board: self.board, position: self.position, brick: brick) {
                brick.rotate()
                clearBrick()
                writeBrick()
            }
        }
    }
    
    private func gameOver() {
        self.gameState = .end
        self.position = Array(startPosition)
        self.brick = nil
        self.finalScore = score
        self.score = 0
        self.board = [[Int]](repeating: [Int](repeating: 0, count: board[0].count), count: board.count)
    }
    
    private func checkFullRow() {
        for (rowIndex, row) in board.enumerated() {
            var fullRow = true
            for (_, value) in row.enumerated() {
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
    
    private func levelUp() {
        score = score + 1
    }
}
