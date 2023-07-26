//
//  NoLocationView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 10.06.2023.
//

import SwiftUI

struct NoLocationView: View {
    var body: some View {
        ScrollView {
            LogoView(showCompass: false)
            HStack {
                VStack (alignment: .leading) {
                    Text("Vítejte")
                        .fontWeight(.bold)
                    
                    Text("na Přírodovědecké fakultě UPOL, katedře Informatiky")
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.bottom)
            }
            Group {
                NavigationLink { PortalView()
                } label: { BannerButtonView(imageName: "BannerPortal", text: "Portal") }
                NavigationLink { LensView()
                } label: { BannerButtonView(imageName: "BannerLens", text: "Lens") }
                MenuView()
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
    }
}

struct NoLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NoLocationView()
    }
}
