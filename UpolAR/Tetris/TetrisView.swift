//
//  TetrisView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.06.2023.
//

import SwiftUI

struct TetrisView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = TetrisViewModel(rows: 10, columns: 6)
    
    var body: some View {
        ZStack {
            TetrisARView(board: $viewModel.board)
                    .ignoresSafeArea()
                    .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                                        .onEnded({ value in
                                            if value.translation.width < -50 {
                                                viewModel.horizontalMove(horizontalMove: .left)
                                            }
                                            if value.translation.width > 50 {
                                                viewModel.horizontalMove(horizontalMove: .right)
                                            }
                                            if value.translation.height < -50 {
                                                viewModel.rotate()
                                            }
                                        }))
        }
        .navigationBarBackButtonHidden(true)
        
        // navigační lišta NavigationView
        .navigationBarItems(
            leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() }),
            trailing: HelpButtonView(action: { viewModel.showAlert() }))
        
        // zobrazení alert okna s informacemi k ovládání
        .alert(isPresented: $viewModel.showingAlert) {
                                Alert(title: Text("Portál"),
                                      message: Text("Přepínejte mezi různými místnostmi gestem swipe doprava nebo doleva.\n👈"),
                                      dismissButton: .default(Text("OK")))
                            }
        .onAppear(perform: viewModel.showAlert)
        
        .onReceive(viewModel.player) { _ in
            viewModel.step()
                        }
        
        .onDisappear {
            viewModel.restart()
        }
    }
}

struct TetrisView_Previews: PreviewProvider {
    static var previews: some View {
        TetrisView()
    }
}
