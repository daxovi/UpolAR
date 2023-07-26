//
//  LogoView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 17.06.2023.
//

import SwiftUI

struct LogoView: View {
    var showCompass: Bool
    @StateObject var viewModel = LogoViewModel()
    var body: some View {
        HStack {
            if showCompass {
                CompassView()
                    .padding(20)
            }
            Spacer()
            Image("LogoUPOL")
                .padding(30)
                .onTapGesture {
                    viewModel.tap()
                }
        }
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(showCompass: true)
    }
}
