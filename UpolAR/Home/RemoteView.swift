//
//  RemoteView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct RemoteView: View {
    @Binding var distance: Float?
    
    var body: some View {
        ScrollView {
            LogoView(showCompass: true)
            header
            Group {
                NavigationLink { PortalView()
                } label: { BannerButtonView(imageName: "BannerPortal", text: "portal.title") }
                NavigationLink { LensView()
                } label: {
                    BannerButtonView(imageName: "BannerLens", text: "lens.title")
                }
                MenuView()
            }
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea()
    }
    
    var header: some View {
        HStack {
            VStack (alignment: .leading) {
                if ((distance ?? 0.0) < 2000) {
                    close
                } else {
                    far
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom)
            Spacer()
        }
    }
    
    // Část View, která se zobrazí pokud je uživael blízko
    var close: some View {
        Group {
            Text("uz.jen")
                .fontWeight(.bold)
            Text("\(Int(distance ?? -1)) jeste.m")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
    }
    
    // Část View, která se zobrazí pokud je uživatel daleko
    var far: some View {
        Group {
            Text("jste")
                .fontWeight(.bold)
            Text("\(Int((distance ?? -1)) / 1000) pojdte.bliz")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
    }
}

struct RemoteView_Previews: PreviewProvider {
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
                RemoteView(distance: .constant(111))
            }
        }
    }
}

