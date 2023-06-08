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
    @Published var isLocationEnabled: Bool
    
    let locationManager: LocationManager
    
    init() {
        locationManager = LocationManager.shared
                
        switch locationManager.getLocationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("DEBUG: location is enabled")
            self.isLocationEnabled = true
            self.isLocationSheetShown = false
            
        case .notDetermined, .restricted, .denied:
            print("DEBUG: location is not enabled")
            self.isLocationEnabled = false
            self.isLocationSheetShown = true
        @unknown default:
            self.isLocationEnabled = false
            self.isLocationSheetShown = true
        }
    }
    
    func getDistance() -> Int {
        if let distance =  locationManager.distanceToDestination {
            print("DEBUG: distance2: \(distance)")
            return Int(distance)
        }
        return -1
    }
    
    func isUserInPlace() -> Bool {
        if let distance =  locationManager.distanceToDestination {
            print("DEBUG: distance: \(distance)")
            return distance < 500
        }
        print("DEBUG: distance: unknown")
        return false
    }
}
