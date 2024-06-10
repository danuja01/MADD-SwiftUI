//
//  CLLocationCoordinate2D.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import CoreLocation
import FirebaseFirestore

extension CLLocationCoordinate2D: Equatable {
    func toGeoPoint() -> GeoPoint {
           return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
