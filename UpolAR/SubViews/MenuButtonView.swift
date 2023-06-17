//
//  MenuButtonView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 08.06.2023.
//

import SwiftUI

struct MenuButtonView: View {
    
    var title: String
    var iconName: String?
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.black)
            Spacer()
            if let iconName {
                Image(systemName: iconName)
                    .foregroundColor(Color("AccentColor"))
            }
        }
            .padding()
            .background(
                Color("MenuButtonColor")
            )
    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(title: "Ahoj", iconName: "link")
    }
}
