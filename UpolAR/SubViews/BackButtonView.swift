//
//  BackButtonView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 26.07.2023.
//

import SwiftUI

struct BackButtonView: View {
    var action: () -> ()
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
                    .font(.title)
                    .padding(.top)
            }
        }
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView(action: {print("DEBUG: button test")})
    }
}

