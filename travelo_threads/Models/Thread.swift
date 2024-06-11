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



var sampleThreads: [Thread] = [
    Thread(
        title: "Beautiful Sunset",
        caption: "Caught a stunning sunset at the beach last weekend!",
        imageUrl: "https://t3.ftcdn.net/jpg/05/28/96/86/360_F_528968647_75C1y4AO39bfmb4BeZJaC5HU9Mx9WsQr.jpg",
        location: CLLocationCoordinate2D(latitude: 34.011286, longitude: -116.166868),
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user",
        userName: "naturelover",
        createdBy: "user123"
    ),
    Thread(
        title: "Snowy Mountains",
        caption: "Here's a breathtaking view of the snowy mountains I visited this winter.",
        imageUrl: "https://t3.ftcdn.net/jpg/05/28/96/86/360_F_528968647_75C1y4AO39bfmb4BeZJaC5HU9Mx9WsQr.jpg",
        location: CLLocationCoordinate2D(latitude: 40.730610, longitude: -73.935242),
        userImage: "https://img.freepik.com/free-photo/portrait-man-laughing_23-2148859448.jpg?size=338&ext=jpg&ga=GA1.1.2116175301.1717977600&semt=ais_user",
        userName: "adventureseeker",
        createdBy: "user456"
    )
]

