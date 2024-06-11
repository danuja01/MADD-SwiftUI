//
//  User.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-11.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    var username: String
    var email: String
    var imageUrl: String
    var likedThreads: [String]
    var savedThreads: [String]
    
    init(username: String, email: String, imageUrl: String, likedThreads: [String] = [], savedThreads: [String] = []) {
        self.username = username
        self.email = email
        self.imageUrl = imageUrl
        self.likedThreads = likedThreads
        self.savedThreads = savedThreads
    }
}
