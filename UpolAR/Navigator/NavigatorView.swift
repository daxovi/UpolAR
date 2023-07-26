//
//  NavigatorView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI

struct NavigatorView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            NavigatorARView()
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() }),
                    trailing: HelpButtonView(action: { viewModel.showAlert() }))
                // zobrazení alert okna s informacemi k ovládání
                .alert(isPresented: $viewModel.showingAlert) {
                    Alert(title: Text("Navigátor"),
                          message: Text("Ztratili jste se? 🫥 Najděte plakáty bludiště 🗺️ v budově fakulty a aplikace vám pomůže."),
                          dismissButton: .default(Text("OK")))}
                .onAppear(perform: viewModel.showAlert)
        }
    }
}

struct NavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
