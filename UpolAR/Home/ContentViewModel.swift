//
//  ContentViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.06.2023.
//

import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {
    
    @Published var isLocationSheetShown: Bool
    
    let locationManager: LocationManager
            
    init() {
        locationManager = LocationManager.shared
                
        // Rozhodne zda je potřeba požádat uživatele o polohové služby
        switch locationManager.getLocationStatus() {
            
        // Pokud sou polohové služby povolené
        case .authorizedAlways, .authorizedWhenInUse:
            print("DEBUG: location is enabled")
            self.isLocationSheetShown = false
            
        // Pokud jenou polohové služby povolené
        case .notDetermined, .restricted, .denied:
            print("DEBUG: location is not enabled")
            self.isLocationSheetShown = true
            
        @unknown default:
            self.isLocationSheetShown = true
        }
    }
}
