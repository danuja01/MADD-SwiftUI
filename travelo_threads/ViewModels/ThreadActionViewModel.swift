//
//  ThreadActionViewModel.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-12.
//

import Combine
import FirebaseAuth
import FirebaseFirestore

class ThreadActionsViewModel: ObservableObject {
    @Published var isLiked: Bool = false
    @Published var isSaved: Bool = false
    @Published var favoriteCount: Int = 0
    
    private var thread: Thread
    private var userId: String
    
    init(thread: Thread, userId: String) {
        self.thread = thread
        self.userId = userId
        fetchUserData()
        fetchFavoriteCount()
    }
    
    func toggleLike() {
        FirebaseManager.shared.toggleLikeThread(threadId: thread.id ?? "", userId: userId, isLiked: isLiked) { success in
            if success {
                self.isLiked.toggle()
                self.favoriteCount += self.isLiked ? 1 : -1
            }
        }
    }
    
    func toggleSave() {
        FirebaseManager.shared.toggleSaveThread(threadId: thread.id ?? "", userId: userId, isSaved: isSaved) { success in
            if success {
                self.isSaved.toggle()
            }
        }
    }
    
    func fetchUserData() {
        FirebaseManager.shared.fetchUserData(userId: userId) { user in
            guard let user = user else { return }
            self.isLiked = user.likedThreads.contains(self.thread.id ?? "")
            self.isSaved = user.savedThreads.contains(self.thread.id ?? "")
        }
    }
    
    func fetchFavoriteCount() {
        let db = Firestore.firestore()
        let threadRef = db.collection("threads").document(thread.id ?? "")
        
        threadRef.getDocument { document, error in
            if let document = document, document.exists {
                if let count = document.data()?["favoriteCount"] as? Int {
                    self.favoriteCount = count
                }
            } else {
                print("Document does not exist")
            }
        }
    }
}
