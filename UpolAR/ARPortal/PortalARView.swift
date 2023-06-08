//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI

struct ARPortalView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
            PortalAR()
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
    }
    
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                BackButtonView()
            }
        }
}

struct ARPortalView_Previews: PreviewProvider {
    static var previews: some View {
        ARPortalView()
    }
}
