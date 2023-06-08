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
        VStack {
            Text("Prosím o vaši polohu.")
            Button("Povolit sdílení polohy") {
                locationManager.requestLocation()
                isLocationSheetShown = false
            }
            Button("zakázat sdílení polohy") {
                isLocationSheetShown = false
            }
        }
    }
}
