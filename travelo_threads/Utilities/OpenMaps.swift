//
//  OpenMaps.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import CoreLocation
import MapKit

func openMaps(for coordinate: CLLocationCoordinate2D, locationName: String?) {
    let placemark = MKPlacemark(coordinate: coordinate)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = locationName
    mapItem.openInMaps(launchOptions: nil)
}

