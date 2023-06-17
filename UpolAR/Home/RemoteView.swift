//
//  RemoteView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI
import Foundation

struct RemoteView: View {
    
    @Binding var distance: Float?
    
    var body: some View {
            ScrollView {
                
                LogoView()
                
                header
                
                Group {
                    NavigationLink { CompassView()
                    } label: {
                        Image("BannerCompass")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 135)
                            .cornerRadius(15)
                            .padding(.bottom)
                            .overlay(
                                VStack {
                                    HStack {
                                        Text("Kompas").fontWeight(.bold)
                                        Spacer()
                                        Image(systemName: "arkit")
                                    }
                                    .font(.title2)
                                    
                                    .foregroundColor(.white)
                                    .padding()
                                    
                                    Spacer()
                                }
                            )
                    }
                    
                    NavigationLink { PortalView()
                    } label: {
                        Image("BannerPortal")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 135)
                            .cornerRadius(15)
                            .padding(.bottom)
                            .overlay(
                                VStack {
                                    HStack {
                                        Text("Portal").fontWeight(.bold)
                                        Spacer()
                                        Image(systemName: "arkit")
                                    }
                                    .font(.title2)
                                    
                                    .foregroundColor(.white)
                                    .padding()
                                    
                                    Spacer()
                                }
                            )
                    }
                    
                    NavigationLink { LensView()
                    } label: {
                        Image("BannerLens")
                            .resizable()
                            .scaledToFill()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 135)
                            .cornerRadius(15)
                            .padding(.bottom)
                            .overlay(
                                VStack {
                                    HStack {
                                        Text("Lens").fontWeight(.bold)
                                        Spacer()
                                        Image(systemName: "arkit")
                                    }
                                    .font(.title2)
                                    
                                    .foregroundColor(.white)
                                    .padding()
                                    
                                    Spacer()
                                }
                            )
                    }
                    
                    NavigationLink { NavigatorView()
                    } label: { MenuButtonView(title: "test", iconName: "arkit") }
                    
                    MenuView()
                }
                .padding(.horizontal, 20)
            }
            .ignoresSafeArea()
           // .background(Color("Background"))
    }
    
    var header: some View {
        VStack (alignment: .leading) {
            if ((distance ?? 0.0) < 1000) {
                close
            } else {
                far
            }
        }
       // .padding(.top, 100)
    //    .padding(.vertical)
        .padding(.horizontal, 20)
     //   .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom)
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
        RemoteView(distance: .constant(111))
    }
}

