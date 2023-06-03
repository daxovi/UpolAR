//
//  LocationManager.swift
//  UpolAR
//
//  Created by Dalibor Janeček on 03.06.2023.
//

import CoreLocation
import SwiftUI
// https://youtu.be/poSmKJ_spts
// https://stackoverflow.com/questions/61706836/getting-the-direction-the-user-is-facing-using-swift

class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()
    
    // MARK: Destination
    // poloha požadované destinace
    let destination = CLLocationCoordinate2D(latitude: 49.592477, longitude: 17.263371)
    
    // souřadnice uživatele
    @Published var userLocation: CLLocation?
    
    // směrování na sever
    @Published var userHeading: Float?
    
    // směrování k místu
    @Published var headingToDestination: Float?
    
    // vzdálenost od místa
    @Published var distanceToDestination: Float?
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    // MARK: Request Location
    // funkce vyšle požadavek na polohové služby
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
}

//
extension LocationManager: CLLocationManagerDelegate {
    
    // MARK: CHange Authorization
    // funkce zjišťuje stav povolení polohových služeb
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: Not determined")
        case .restricted:
            print("DEBUG: Restricted")
        case .denied:
            print("DEBUG: Denied")
        case .authorizedAlways:
            print("DEBUG: Auth always")
        case .authorizedWhenInUse:
            print("DEBUG: Auth when in use")
        default:
            break
        }
    }
    
    // MARK: Update Location
    // funkce, která se spustí vždy když se změní poloha uživatele
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        let distance = location.distance(from: .init(latitude: destination.latitude, longitude: destination.longitude))
        self.distanceToDestination = Float(distance)
    }
    
    // MARK: Update Heading
    // funkce, která se spustí vždy když se změní směrování uživatele
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let heading = newHeading.trueHeading
        self.userHeading = Float(heading)
        
        guard let a = userLocation?.coordinate else { return }
        let b = destination
        let deltaL = b.longitude.toRadians - a.longitude.toRadians
        let thetaB = b.latitude.toRadians
        let thetaA = a.latitude.toRadians
        let x = cos(thetaB) * sin(deltaL)
        let y = cos(thetaA) * sin(thetaB) - sin(thetaA) * cos(thetaB) * cos(deltaL)
        let bearing = atan2(x,y)
        let bearingInDegrees = bearing.toDegrees
        
        let myHeading = Double(heading)
        let bearingFromMe =  myHeading - bearingInDegrees
        self.headingToDestination = Float(bearingFromMe)
    }
}

extension Double {
    var toRadians : Double {
        var m = Measurement(value: self, unit: UnitAngle.degrees)
        m.convert(to: .radians)
        return m.value
    }
    var toDegrees : Double {
        var m = Measurement(value: self, unit: UnitAngle.radians)
        m.convert(to: .degrees)
        return m.value
    }
}
