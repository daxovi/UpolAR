//
//  LensView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.06.2023.
//

import SwiftUI

struct LensView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            LensARView()
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() })
                )
        }
        
    }
}

struct LensView_Previews: PreviewProvider {
    static var previews: some View {
        LensView()
    }
}
