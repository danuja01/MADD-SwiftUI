//
//  Thread.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//
import SwiftUI
import CoreLocation
import Foundation

struct Thread: Identifiable, Equatable {
    var id: String
    var title: String
    var caption: String
    var imageUrl: String?
    var location: CLLocationCoordinate2D
    var userImage: String
    var userName: String
    var favoriteCount: Int
}

var sampleThreads = [
    Thread(
        id: "1",
        title: "Mountain Hike",
        caption: "Enjoying the breathtaking views of the Alps.",
        imageUrl: "https://ichef.bbci.co.uk/images/ic/1376xn/p0b7n6dm.jpg.webp",
        location: CLLocationCoordinate2D(latitude: 46.0207, longitude: 7.7491),
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        userName: "Alice Hudson",
        favoriteCount: 15
    ),
    Thread(
        id: "2",
        title: "Way to Sigiriya",
        caption: "Lats day I wen to Sigiriya with my friends and it was and unbelievable construction on a Rock!!",
        imageUrl: nil,
        location: CLLocationCoordinate2D(latitude: 7.956944, longitude: 80.759720 ),
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        userName: "Bob Marley",
        favoriteCount: 8
    ),
    Thread(
        id: "3",
        title: "Desert Safari",
        caption: "An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.An adventure in the Sahara Desert.",
        imageUrl: "https://ichef.bbci.co.uk/images/ic/1376xn/p0b7n6dm.jpg.webp",
        location: CLLocationCoordinate2D(latitude: 23.4162, longitude: 25.6628),
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        userName: "Carol Spat",
        favoriteCount: 20
    ),
    Thread(
        id: "4",
        title: "Ocean Retreat",
        caption: "Relaxing by the serene Maldives beaches.",
        imageUrl: nil,
        location: CLLocationCoordinate2D(latitude: 1.9772, longitude: 73.5361),
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        userName: "Dave John",
        favoriteCount: 25
    ),
    Thread(
        id: "5",
        title: "Forest Camping",
        caption: "Camping in the mystic woods of the Amazon.",
        imageUrl: "https://ichef.bbci.co.uk/images/ic/1376xn/p0b7n6dm.jpg.webp",
        location: CLLocationCoordinate2D(latitude: -3.4653, longitude: -62.2159),
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        userName: "Eva Clark",
        favoriteCount: 10
    )
]

