//
//  ARNavigatorView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct NavigatorView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        NavigatorARView()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() }))

    }
}

struct ARNavigatorView_Previews: PreviewProvider {
    static var previews: some View {
        NavigatorView()
    }
}
