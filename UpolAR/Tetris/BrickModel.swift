//
//  BrickModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 21.06.2023.
//

class BrickModel {
    var mesh: [[Int]]
    var type: BrickType
    
    init(type: BrickType) {
        self.type = type
        
        switch type {
        case .corner:
            self.mesh = [
                [0, 1],
                [1, 1]
            ]
        case .el:
            self.mesh = [
                [0, 1],
                [0, 1],
                [1, 1]
            ]
        case .square:
            self.mesh = [
                [1, 1],
                [1, 1]
            ]
        case .line:
            self.mesh = [
                [1],
                [1],
                [1],
                [1]
            ]
        case .tshirt:
            self.mesh = [
                [0, 1, 0],
                [1, 1, 1]
            ]
        case .zet:
            self.mesh = [
                [1, 1, 0],
                [0, 1, 1]
            ]
        case .jee:
            self.mesh = [
                [1, 0],
                [1, 0],
                [1, 1]
            ]
        }
    }
    
    func rotate(clockwise: Bool = true) {
        let rows = mesh.count
        let columns = mesh[0].count
        var newMesh = Array(repeating: Array(repeating: 0, count: rows), count: columns)
        for column in 0..<columns {
            for row in 0..<rows {
                newMesh[column][row] = clockwise ? mesh[rows - row - 1][column] : mesh[row][columns - column - 1]
            }
        }
        mesh = newMesh
    }
}

enum BrickType {
    case square, el, corner, line, tshirt, zet, jee
}
