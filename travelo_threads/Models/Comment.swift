//
//  Comment.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Comment: Identifiable, Codable {
    @DocumentID var id: String?
    var text: String
    var createdBy: String
    var userName: String
    var userImage: String
    var timestamp: Timestamp

    init(text: String, createdBy: String, userName: String, userImage: String) {
        self.text = text
        self.createdBy = createdBy
        self.userName = userName
        self.userImage = userImage
        self.timestamp = Timestamp(date: Date())
    }
}



