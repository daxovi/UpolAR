//
//  BannerButtonView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 18.06.2023.
//

import SwiftUI

// View, které zobrazí velký banner na AR část.
struct BannerButtonView: View {
    var imageName: String
    var text: LocalizedStringKey
    var iconName: String = "arkit"
    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .frame(height: 135)
            .cornerRadius(15)
            .padding(.bottom, 10)
            .overlay(
                VStack {
                    HStack {
                        Text(text).fontWeight(.bold)
                        Spacer()
                        Image(systemName: iconName)
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }
            )
    }
}
