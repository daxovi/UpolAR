//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI

struct PortalView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var roomNr = 1

    var body: some View {
        ZStack {
            PortalARView(roomNr: $roomNr)
                    .ignoresSafeArea()
                    
            Button(action: {
                roomNr = 2
                print("DEBUG: changed room nr")
            }, label: {
                Text("2 \(roomNr)")
                    .padding()
                    .background(Color.blue)
                    .padding()
            })
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        
    }
    
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                BackButtonView()
            }
        }
}

struct ARPortalView_Previews: PreviewProvider {
    static var previews: some View {
        PortalView()
    }
}
