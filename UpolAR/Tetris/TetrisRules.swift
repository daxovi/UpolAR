//
//  TetrisRules.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 29.07.2023.
//

import Foundation

struct TetrisRules {
    let rows: Int
    let columns: Int
    
    func isMoveValid(board: [[Int]]) -> Bool {
        var value = true
        // prochází pole odspodu
        for rowIndex in (0..<rows) {
            // prochází řádek zleva doprava
            for colIndex in 0..<columns {
                // jestliže je na místě 1
                if board[rowIndex][colIndex] == 1 {
                    // jestliže není posunutí mimo pole
                    if rowIndex+1 < rows {
                        // jestliže je pod jedničkou jiná hodnota než 2
                        if board[rowIndex+1][colIndex] != 2 {
                            value = value && true
                        } else {return false}
                    } else {return false}
                }
            }
        }
        return value
    }
    
    func isHorizontalMoveValid(board: [[Int]], move: Move) -> Bool {
        var value = true
        for rowIndex in (0..<rows) {
            for colIndex in (0..<columns) {
                if board[rowIndex][colIndex] == 1 {
                    // jestliže není posunutí mimo pole
                    if colIndex + move.rawValue < columns && colIndex + move.rawValue > -1 {
                        if board[rowIndex][colIndex + move.rawValue] != 2 {
                            value = value && true
                        } else {return false}
                    } else {return false}
                }
            }
        }
        return value
    }
    
    func isRotationValid(board: [[Int]], position: [Int], brick: BrickModel) -> Bool {
        var value = true
        let nextBoard = Array(board)
        brick.rotate()
        
        for rowIndex in 0..<brick.mesh.count {
            for columnIndex in 0..<brick.mesh[rowIndex].count {
                // jestliže je v poli kostky 1
                if brick.mesh[rowIndex][columnIndex] == 1 {
                    // zkontroluje jestli je index v poli
                    if 0..<board.count ~= rowIndex + position[0] && 0..<board[0].count ~= columnIndex + position[1] {
                        // zkontroluje jestli na indexu není 2
                        if nextBoard[rowIndex + position[0]][columnIndex + position[1]] != 2 {
                            value = value && true
                        } else {
                            value = false
                        }
                    } else {
                        value = false
                    }
                }
            }
        }
        brick.rotate(clockwise: false)
        return value
    }
    
    func isgameOver(board: [[Int]]) -> Bool {
        for column in board[0] {
            if column == 2 {
                return true
            }
        }
        return false
    }
}
