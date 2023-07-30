//
//  TetrisView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.06.2023.
//

import SwiftUI

struct TetrisView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = TetrisViewModel.shared
    
    var body: some View {
        ZStack {
            TetrisARView(board: $viewModel.board, score: $viewModel.score, finalScore: $viewModel.finalScore, gameState: $viewModel.gameState)
                .ignoresSafeArea()
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded({ value in viewModel.gestureRecognizer(value: value) }))
        }
        .navigationBarBackButtonHidden(true)
        // navigační lišta NavigationView
        .navigationBarItems(
            leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() }),
            trailing: HelpButtonView(action: { viewModel.showAlert() }))
        // zobrazení alert okna s informacemi k ovládání
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("tetris.title"),
                  message: Text("tetris.description"),
                  dismissButton: .default(Text("ok")))
        }
        .onAppear(perform: viewModel.showAlert)
        .onReceive(viewModel.player) { _ in
            viewModel.renderGame()
        }
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
