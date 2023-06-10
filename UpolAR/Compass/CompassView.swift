//
//  ARCompassView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI

struct CompassView: View {
    
    @State var showModel = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ZStack {
            CompassARView(showModel: $showModel)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: backButton)
            VStack {
                Spacer()
                    if !showModel {
                        Button {
                            withAnimation {
                                showModel = true
                            }
                            
                        } label: {
                            Text("Show model")
                                .padding()
                                .frame(width: 200)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    } else {
                        Button {
                            withAnimation {
                                showModel = false
                            }
                        } label: {
                            Text("Remove model")
                                .padding()
                                .frame(width: 200)
                                .background(Color.red)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                    }
            }
            .padding()
        }
        
    }
    
    var backButton : some View { Button(action: {
            self.presentationMode.wrappedValue.dismiss()
            }) {
                BackButtonView()
            }
        }
}



struct ARCompassView_Previews: PreviewProvider {
    static var previews: some View {
        CompassView()
    }
}
