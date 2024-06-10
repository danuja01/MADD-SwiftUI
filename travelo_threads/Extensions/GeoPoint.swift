//
//  GeoPoint.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import CoreLocation
import FirebaseFirestore

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
