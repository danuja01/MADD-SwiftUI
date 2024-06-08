//
//  Comment.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import Foundation

struct Comment: Identifiable {
    var id: String
    var text: String
    var createdBy: String
    var userName: String
    var userImage: String
    var timestamp: Date
}

var sampleComments = [
    Comment(
        id: "comment1",
        text: "Really love the vibrant colors in this photo!",
        createdBy: "user001",
        userName: "Alice Smith",
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        timestamp: Date()
    ),
    Comment(
        id: "comment2",
        text: "This brings back great memories, thank you for sharing!",
        createdBy: "user002",
        userName: "Bob Johnson",
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        timestamp: Date().addingTimeInterval(-86400) // 1 day ago
    ),
    Comment(
        id: "comment3",
        text: "Can't wait to visit this place myself!",
        createdBy: "user003",
        userName: "Carol Lee",
        userImage: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
        timestamp: Date().addingTimeInterval(-172800) // 2 days ago
    )
]


