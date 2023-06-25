//
//  ComputerView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 24.06.2023.
//

import SwiftUI

struct ComputerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ComputerARView()
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() })
            )
    }
}

struct ComputerView_Previews: PreviewProvider {
    static var previews: some View {
        ComputerView()
    }
}
