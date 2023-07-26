//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI

struct PortalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = PortalViewModel()
    
    var body: some View {
        ZStack {
            PortalARView(roomFileName: $viewModel.roomFileName, fileExtension: viewModel.fileExtension)
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
            Alert(title: Text("Portál"),
                  message: Text("Přepínejte mezi různými místnostmi gestem swipe doprava nebo doleva.\n👈"),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: viewModel.showAlert)
    }
}

struct ARPortalView_Previews: PreviewProvider {
    static var previews: some View {
        PortalView()
    }
}
