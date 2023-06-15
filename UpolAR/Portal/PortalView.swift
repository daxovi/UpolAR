//
//  PortalARView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.03.2022.
//

import SwiftUI

struct PortalView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   // @State var roomNr = 0
    
    @StateObject var viewModel = PortalViewModel()

    var body: some View {
        ZStack {
            PortalARView(roomFileName: $viewModel.roomFileName, fileExtension: viewModel.fileExtension)
                    .ignoresSafeArea()
                    .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                                        .onEnded({ value in
                                            if value.translation.width < 0 {
                                                viewModel.nextRoom()
                                            }
                                            if value.translation.width > 0 {
                                                viewModel.prevRoom()
                                            }
                                        }))
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
