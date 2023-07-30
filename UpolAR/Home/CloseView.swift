//
//  CloseView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct CloseView: View {
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
                NavigationLink { NavigatorView()
                } label: { BannerButtonView(imageName: "BannerNavigator", text: "navigator.title") }
                NavigationLink { ComputerView()
                } label: { BannerButtonView(imageName: "BannerComputer", text: "computer.title") }
                NavigationLink { TetrisView()
                } label: { BannerButtonView(imageName: "BannerTetris", text: "tetris.title") }
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

struct CloseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color("BlueColor").ignoresSafeArea()
                VStack {
                    HStack {
                        Image("Lines")
                        Spacer()
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                CloseView()
            }
        }
    }
}
