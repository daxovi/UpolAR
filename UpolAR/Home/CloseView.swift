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
                
                LogoView()
                
                VStack (alignment: .leading) {
                    Text("Vítejte")
                        .fontWeight(.bold)
                    
                    Text("na Přírodovědecké fakultě UPOL, katedře Informatiky")
                }
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.bottom)
                
                Group {
                    NavigationLink { CompassView()
                    } label: { MenuButtonView(title: "Kompas", iconName: "arkit") }
                    
                    NavigationLink { PortalView()
                    } label: { MenuButtonView(title: "Portal AR", iconName: "arkit") }
                    
                    NavigationLink { NavigatorView()
                    } label: { MenuButtonView(title: "test", iconName: "arkit") }
                    
                    MenuView()
                }
                .padding(.horizontal, 20)
                }
            .ignoresSafeArea()
    }
}

struct CloseView_Previews: PreviewProvider {
    static var previews: some View {
        CloseView()
    }
}
