//
//  BackButtonView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct BackButtonView: View {
    var body: some View {
        HStack {
        Image(systemName: "xmark.circle.fill")
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.red)
            .font(.title)
        }
    }
}

struct BackButtonView_Previews: PreviewProvider {
    static var previews: some View {
        BackButtonView()
    }
}
