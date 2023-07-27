//
//  HelpButtonView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.06.2023.
//

import SwiftUI

struct HelpButtonView: View {
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            Text("napoveda")
                .padding(.top)
        }
    }
}

struct HelpButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HelpButtonView(action: { print("DEBUG: test view")})
    }
}
