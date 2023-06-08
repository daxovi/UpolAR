//
//  CloseView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 07.06.2023.
//

import SwiftUI

struct CloseView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Vítejte")
                        .fontWeight(.bold)
                    
                    Text("na Přírodovědecké fakultě UPOL, katedře Informatiky")
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 200)
                .padding(.vertical)
                .padding(.horizontal, 20)
                .frame(width: UIScreen.main.bounds.width)
                .background {
                    Color("BlueColor")
                }
                .padding(.bottom)
                Group {
                    NavigationLink {
                        ARCompassView()
                    } label: {
                        MenuButtonView(title: "Kompas")
                    }
                    
                    NavigationLink {
                        ARPortalView()
                    } label: {
                        MenuButtonView(title: "Portal AR")
                    }
                    
                    NavigationLink {
                        ARNavigatorView()
                    } label: {
                        MenuButtonView(title: "test")
                    }
                    
                    MenuView()
                }
                .padding(.horizontal, 20)
                }
            
            .ignoresSafeArea()

        }

    }
}

struct CloseView_Previews: PreviewProvider {
    static var previews: some View {
        CloseView()
    }
}