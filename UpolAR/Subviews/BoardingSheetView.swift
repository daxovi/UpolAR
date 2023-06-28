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
    
    var body: some View {
        ZStack {
            Image("Location")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: UIScreen.main.bounds.height)
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
                Text("Vítejte")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Aplikace vám pomůže se seznámením se s Univerzitou Palackého v Olomouc a Katedrou informatiky. \n\n Aplikace využívá fotoaparát telefonu pro zobrazení rozšířené reality.")
                Spacer()
                
                VStack(spacing: 10) {
                    Button("pokračovat") {
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
                Text("Pojďte blíž")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Aplikace se bude přizpůsobovat na základě vaší vzdálenosti od Přírodovědecké fakulty UPOL. \n\n Nejlepší zážitek vám nabídne v budově Přírodovědecké fakulty UPOL. Stačí sledovat plakáty se symbolem AR")
                Image(systemName: "arkit")
                    .font(.title2)
                
                VStack(spacing: 10) {
                    Button("povolit polohové služby") {
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

                    Button("nepovolovat polohové služby") {
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

