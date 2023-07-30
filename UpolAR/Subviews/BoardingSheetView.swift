//
//  LocationSheetView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.06.2023.
//

import SwiftUI

struct BoardingSheetView: View {
    enum BoardingState: Equatable {
        case welcome, location
    }
    let locationManager = LocationManager.shared
    @Binding var isLocationSheetShown: Bool
    @State var boardingState: BoardingState = .welcome
    @State var size: CGSize = .zero

    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                            HStack {}
                                .onAppear {
                                    size = proxy.size
                                }
                        }
            Image("Location")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: size.height)
            if boardingState == .welcome {
                welcome
                    .transition(.move(edge: .leading))
            } else {
                location
                    .transition(.move(edge: .trailing))
            }
        }
    }
    
    var welcome: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text("vitejte")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("aplikace.pomuze")
            Spacer()
            
            VStack(spacing: 10) {
                Button("pokracovat") {
                    withAnimation {
                        boardingState = .location
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color("BlueColor")
                        .cornerRadius(10)
                )
                .padding(.horizontal)
                .padding()
            }
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
    }
    
    var location: some View {
        VStack(spacing: 20) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Text("pojdte.bliz")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("aplikace.prizpusobovat")
            Image(systemName: "arkit")
                .font(.title2)
            VStack(spacing: 10) {
                Button("povolit.polohove") {
                    locationManager.requestLocation()
                    isLocationSheetShown = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    Color("BlueColor")
                        .cornerRadius(10)
                )
                .padding(.horizontal)
                Button("zakazat.polohove") {
                    isLocationSheetShown = false
                }
                .padding()
            }
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
    }
}

struct LocationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BoardingSheetView(isLocationSheetShown: .constant(true))
    }
}

