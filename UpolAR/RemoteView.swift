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
        NavigationView {
            ScrollView {
                VStack (alignment: .leading) {
                    if ((distance ?? 0.0) < 1000) {
                        close
                    } else {
                        far
                    }
                }
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
    
    var close: some View {
        Group {
            Text("Už jen")
                .fontWeight(.bold)
            Text("\(Int(distance ?? -1)) metrů a budete na Přírodovědecké fakultě UPOL")
        }
        .font(.largeTitle)
        .foregroundColor(.white)
    }
    
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

/*
 struct RemoteView_Previews: PreviewProvider {
 static var previews: some View {
 RemoteView(distance: 100)
 }
 }
 */
