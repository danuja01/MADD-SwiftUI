//
//  Thread.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct Thread: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var caption: String
    var imageUrl: String?
    var location: GeoPoint?
    var userImage: String
    var userName: String
    var favoriteCount: Int = 0
    var createdBy: String
    var createdAt: Timestamp

    init(title: String, caption: String, imageUrl: String?, location: CLLocationCoordinate2D?, userImage: String, userName: String, createdBy: String) {
        self.title = title
        self.caption = caption
        self.imageUrl = imageUrl
        if let location = location {
            self.location = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        } else {
            self.location = nil
        }
        self.userImage = userImage
        self.userName = userName
        self.createdBy = createdBy
        self.createdAt = Timestamp(date: Date())
    }
}



var sampleThreads:[Thread] = [
    
]

