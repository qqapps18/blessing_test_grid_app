//
//  DaytimeProvider.swift
//  Sidur
//
//  Created by Andrés Pesate on 19/05/2019.
//  Copyright © 2019 Andrés Pesate. All rights reserved.
//

import Foundation

struct DaytimeProvider {

    private let defaultSunriseTime = Calendar(identifier: Calendar.Identifier.gregorian).date(bySettingHour: 6, minute: 0, second: 0, of: Date())!
    private let defaultSunsetTime = Calendar(identifier: Calendar.Identifier.gregorian).date(bySettingHour: 18, minute: 0, second: 0, of: Date())!

    private let locationManager: LocationManager
    private var locationChangeObserverKey: NSKeyValueObservation?

    init(locationManager: LocationManager = LocationManager.shared) {
        self.locationManager = locationManager
    }

    // MARK: Interface

    var isAfterMidday: Bool {
        let currentHour = Calendar(identifier: .gregorian).component(.hour, from: Date())

        return currentHour >= 12
    }

    var isAfterSunset: Bool {
        return Date().compare(sunset) == .orderedDescending
    }

    var sunrise: Date {
        guard let location = locationManager.location else {
            return defaultSunriseTime
        }

        let solar = Solar(coordinate: location.coordinate)
        return solar?.sunrise ?? defaultSunriseTime
    }

    var sunset: Date {
        guard let location = locationManager.location else {
            return defaultSunsetTime
        }

        let solar = Solar(coordinate: location.coordinate)
        return solar?.sunset ?? defaultSunsetTime
    }

}
