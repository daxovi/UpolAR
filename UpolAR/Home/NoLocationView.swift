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
                        Text("vitejte")
                            .fontWeight(.bold)
                        Text("na.prf")
                    }
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                Spacer()
            }
            Group {
                NavigationLink { PortalView()
                } label: { BannerButtonView(imageName: "BannerPortal", text: "portal.title") }
                NavigationLink { LensView()
                } label: { BannerButtonView(imageName: "BannerLens", text: "lens.title") }
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
