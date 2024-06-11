//
//  CommentsViewModel.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-12.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class CommentsViewModel: ObservableObject {
    @Published var comments: [Comment] = []
    var threadId: String

    init(threadId: String) {
        self.threadId = threadId
        fetchComments()
    }

    func fetchComments() {
        FirebaseManager.shared.fetchComments(threadId: threadId) { fetchedComments in
            self.comments = fetchedComments.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        }
    }

    func addComment(text: String, userName: String, userImage: String, userId: String) {
        let newComment = Comment(
            text: text,
            createdBy: userId,
            userName: userName,
            userImage: userImage
        )
        
        FirebaseManager.shared.addComment(threadId: threadId, comment: newComment) { success, error in
            if success {
                self.fetchComments()
            } else {
                print("Error adding comment: \(error ?? "Unknown error")")
            }
        }
    }

    func deleteComment(_ comment: Comment) {
        FirebaseManager.shared.deleteComment(threadId: threadId, commentId: comment.id ?? "") { success, error in
            if success {
                self.fetchComments()
            } else {
                print("Error deleting comment: \(error ?? "Unknown error")")
            }
        }
    }
}
