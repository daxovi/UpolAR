//
//  LocationSheetView.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.06.2023.
//

import SwiftUI

struct LocationSheetView: View {
    
    let locationManager = LocationManager.shared
    @Binding var isLocationSheetShown: Bool
    
    var body: some View {
        ZStack {
            Image("Location")
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            VStack(spacing: 20) {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text("Prosím povolte polohové služby")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Aplikace se bude přizpůsobovat na základě vaší vzdálenosti od Přírodovědecké fakulty UPOL.")
                Spacer()
                
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
}

struct LocationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSheetView(isLocationSheetShown: .constant(true))
    }
}

