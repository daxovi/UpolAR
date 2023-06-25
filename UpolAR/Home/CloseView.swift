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
                    NavigationLink { NavigatorView()
                    } label: {
                        BannerButtonView(imageName: "BannerNavigator", text: "Navigátor")
                    }
                    
                    NavigationLink { ComputerView()
                    } label: {
                        BannerButtonView(imageName: "BannerComputer", text: "Computer")
                    }
                    
                    NavigationLink { TetrisView()
                    } label: {
                        BannerButtonView(imageName: "BannerTetris", text: "Tetris")
                    }
                    
                    NavigationLink { PortalView()
                    } label: {
                        BannerButtonView(imageName: "BannerPortal", text: "Portal")
                    }
                    
                    NavigationLink { LensView()
                    } label: {
                        BannerButtonView(imageName: "BannerLens", text: "Lens")
                    }
                    
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
