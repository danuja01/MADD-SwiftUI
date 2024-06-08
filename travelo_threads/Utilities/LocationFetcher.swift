import SwiftUI
import CoreLocation
import Combine

class LocationFetcher: ObservableObject {
    @Published var locationName: String = "Loading..."
    private var fetchedCoordinate: CLLocationCoordinate2D?
    private var cancellable: AnyCancellable?
    
    func fetchLocation(for coordinate: CLLocationCoordinate2D) {
        guard fetchedCoordinate != coordinate else { return }
        
        fetchedCoordinate = coordinate
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemarks = placemarks, !placemarks.isEmpty {
                if let place = placemarks.first {
                    if let locality = place.locality, let country = place.country {
                        self?.locationName = "\(locality), \(country)"
                    } else if let name = place.name {
                        self?.locationName = name
                    } else {
                        self?.locationName = "Unknown location"
                    }
                }
            } else if let error = error {
                print("Error finding location: \(error.localizedDescription)")
                self?.locationName = "Error finding location"
            } else {
                self?.locationName = "No address found"
            }
        }
    }
}
