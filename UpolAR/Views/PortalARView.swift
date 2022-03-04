//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI

struct PortalARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            PortalAR().edgesIgnoringSafeArea(.all)
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            Color.red
                                .cornerRadius(10)
                        )
                        .padding()
                }
                Spacer()
            }
        }
    }
}

struct PortalARView_Previews: PreviewProvider {
    static var previews: some View {
        PortalARView()
    }
}
