//
//  ThreadsViewModel.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-11.
//

import SwiftUI
import Combine
import FirebaseAuth

class ThreadsViewModel: ObservableObject {
    @Published var threads: [Thread] = []
    @Published var savedThreads: [Thread] = []
    
    init() {
        fetchThreads()
    }
    
    func fetchThreads() {
        FirebaseManager.shared.fetchThreads { fetchedThreads in
            DispatchQueue.main.async {
                self.threads = fetchedThreads
            }
        }
    }
    
    func fetchSavedThreads(userId: String) {
        FirebaseManager.shared.fetchSavedThreads(userId: userId) { fetchedThreads in
            DispatchQueue.main.async {
                self.savedThreads = fetchedThreads
            }
        }
    }
    
    func addThread(_ thread: Thread, image: UIImage?, completion: @escaping (Bool, String?) -> Void) {
        FirebaseManager.shared.addNewThread(thread: thread, image: image) { success, message in
            if success {
                self.fetchThreads()
            }
            completion(success, message)
        }
    }
    
    func deleteThread(_ thread: Thread, completion: @escaping (Bool, String?) -> Void) {
        guard let threadId = thread.id else { return }
        FirebaseManager.shared.deleteThread(threadId: threadId) { success, message in
            if success {
                self.fetchThreads()
            }
            completion(success, message)
        }
    }
    
    func toggleSaveThread(_ thread: Thread, isSaved: Bool, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.toggleSaveThread(threadId: thread.id ?? "", userId: userId, isSaved: isSaved) { success in
            if success {
                if isSaved {
                    self.savedThreads.removeAll { $0.id == thread.id }
                } else {
                    self.fetchSavedThreads(userId: userId)
                }
            }
            completion(success)
        }
    }
}
