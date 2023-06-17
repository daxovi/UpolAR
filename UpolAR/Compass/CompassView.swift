//
//  ARCompassView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI

struct CompassView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            CompassARView()
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: BackButtonView(action: { self.presentationMode.wrappedValue.dismiss() })
                )
        }
        
    }
}



struct ARCompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
