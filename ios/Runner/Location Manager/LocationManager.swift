//
//  LocationManager.swift
//  Sidur
//
//  Created by Andrés Pesate on 19/05/2019.
//  Copyright © 2019 Andrés Pesate. All rights reserved.
//

import Foundation
import CoreLocation

@objc class LocationManager: NSObject {

    static let shared = LocationManager()

    private let locationManager = CLLocationManager()
    private(set) var location: CLLocation?

    override init() {
        super.init()

        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
    }

    func askForPermission() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            print("The app has permission to access the users location.")
            locationManager.requestLocation()

        case .restricted, .denied:
            print("Show error message asking to grant location permission")

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("\(#file) New location permission status unhandled.")
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }

        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        NotificationCenter.default.post(name: .userLocationsFound, object: nil)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get users location. \(String(describing: error.localizedDescription))")
    }

}

extension Notification.Name {

    static let userLocationsFound = Notification.Name("userLocationsFound")
    
}
