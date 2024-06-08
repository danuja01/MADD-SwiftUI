//
//  CLLocationCoordinate2D.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
