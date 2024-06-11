//
//  ThreadsViewModel.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-11.
//

import SwiftUI
import Combine

class ThreadsViewModel: ObservableObject {
    @Published var threads: [Thread] = []

    func fetchThreads() {
        FirebaseManager.shared.fetchThreads { fetchedThreads in
            DispatchQueue.main.async {
                self.threads = fetchedThreads
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
    
    func updateThread(_ updatedThread: Thread) {
            guard let index = threads.firstIndex(where: { $0.id == updatedThread.id }) else { return }
            threads[index] = updatedThread
        }
}
