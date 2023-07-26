//
//  ComputerView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI

struct ComputerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ComputerARView()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() }),
                trailing: HelpButtonView(action: { viewModel.showAlert() }))
            // zobrazení alert okna s informacemi k ovládání
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text("Computer"),
                      message: Text("Najděte na katedře staré počítače a oživte jejich obrazovky. \n(c) copyright 2008, Blender Foundation / www.bigbuckbunny.org"),
                      dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: viewModel.showAlert)
    }
}

struct ComputerView_Previews: PreviewProvider {
    static var previews: some View {
        ComputerView()
    }
}
