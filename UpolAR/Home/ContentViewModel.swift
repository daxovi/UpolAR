//
//  ContentViewModel.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 04.06.2023.
//

import Combine
import SwiftUI

class ContentViewModel: ObservableObject {
    // řídí zobrazení LocationSheet
    @Published var isLocationSheetShown: Bool
    // vzdálenost od místa
    @Published var distanceToDestination: Float?
    // určí jestli je uživatel blíž místa z destination než je vzdálenost maximumDistance
    @Published var isUserInPlace = false
    
    var cancellables = Set<AnyCancellable>()
    let locationManager: LocationManager
    
    init() {
        locationManager = LocationManager.shared
        // Rozhodne zda je potřeba požádat uživatele o polohové služby
        switch locationManager.getLocationStatus() {
        // Pokud sou polohové služby povolené
        case .authorizedAlways, .authorizedWhenInUse:
            self.isLocationSheetShown = false
            locationManager.$distanceToDestination.sink { value in
                self.distanceToDestination = value
            }
            .store(in: &cancellables)
            locationManager.$isUserInPlace.sink { value in
                self.isUserInPlace = value
            }
            .store(in: &cancellables)
        // Pokud nejsou polohové služby povolené
        case .notDetermined, .restricted, .denied:
            self.isLocationSheetShown = true
        @unknown default:
            self.isLocationSheetShown = true
        }
    }
}
