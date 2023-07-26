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
                } label: { BannerButtonView(imageName: "BannerPortal", text: "Portal") }
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
        }
    }
    
    // Část View, která se zobrazí pokud je uživael blízko
    var close: some View {
        Group {
            Text("Už jen")
                .fontWeight(.bold)
            Text("\(Int(distance ?? -1)) metrů a budete na Přírodovědecké fakultě UPOL")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
    }
    
    // Část View, která se zobrazí pokud je uživatel daleko
    var far: some View {
        Group {
            Text("Jste")
                .fontWeight(.bold)
            Text("\(Int((distance ?? -1)) / 1000) km od Přírodovědecké fakulty UPOL. Pojďte blíž.")
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

