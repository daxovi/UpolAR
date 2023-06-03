//
//  ARCompassView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import SwiftUI

struct ARCompassView: View {
    
    @ObservedObject private var viewModel = ARCompassViewModel()
    
    var body: some View {
        ZStack {
            ARViewUIViewRepresentable(showModel: $viewModel.showModel, update: viewModel.update)
                .ignoresSafeArea()
            VStack {
                Spacer()
                if !viewModel.showModel {
                        Button {
                            withAnimation {
                                viewModel.toggleShowModel()
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
                                viewModel.toggleShowModel()
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
}
struct ARCompassView_Previews: PreviewProvider {
    static var previews: some View {
        ARCompassView()
    }
}
