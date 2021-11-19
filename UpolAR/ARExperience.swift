//
//  ARExperience.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 19.11.2021.
//

import SwiftUI

struct ARExperience: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("close")
        }

    }
}

struct ARExperience_Previews: PreviewProvider {
    static var previews: some View {
        ARExperience()
    }
}
