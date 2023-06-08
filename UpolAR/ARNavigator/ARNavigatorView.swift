//
//  ARNavigatorView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct ARNavigatorView: View {
    
    @ObservedObject private var viewModel = ARNavigatorViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>


    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                BackButtonView()
            }
        }
    
    var body: some View {
        ARViewUIViewRepresentable(showModel: $viewModel.showModel, update: viewModel.update)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)

    }
}

struct ARNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        ARNavigatorView()
    }
}
