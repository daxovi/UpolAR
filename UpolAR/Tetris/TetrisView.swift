//
//  TetrisView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.06.2023.
//

import SwiftUI

struct TetrisView: View {
    
    @StateObject var viewModel = TetrisViewModel(rows: 10, columns: 6)
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.board, id: \.self) { row in
                HStack(spacing: 0) {
                            ForEach(row, id: \.self) { value in
                                Text("\(value)")
                                    .frame(width: 30, height: 30)
                                    .border(Color.black)
                            }
                        }
                    }
            Spacer()
            Button("rotate", action: {viewModel.rotate()})
            HStack {
                Button("left", action: {viewModel.horizontalMove(horizontalMove: .left)})
                Spacer()
                Button("restart", action: viewModel.restart)
                Spacer()
                Button("right", action: {viewModel.horizontalMove(horizontalMove: .right)})
            }
            .padding()
                }
        .onReceive(viewModel.player) { _ in
                            print("tick")
            viewModel.step()
                        }
                    
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
