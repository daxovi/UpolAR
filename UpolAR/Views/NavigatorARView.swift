//
//  ARNavigator.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 05.12.2021.
//


import SwiftUI

struct NavigatorARView : View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            NavigatorAR().edgesIgnoringSafeArea(.all)
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("close")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .padding()
            }
            
        }
    }
}


#if DEBUG
struct ARNavigator_Previews : PreviewProvider {
    static var previews: some View {
        NavigatorARView()
    }
}
#endif
