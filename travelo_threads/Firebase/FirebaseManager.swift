//
//  FirebaseManager.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import UIKit

class FirebaseManager {
    static let shared = FirebaseManager()  // Singleton instance
    private init() {}
    
    private let db = Firestore.firestore()
    
    func createUser(email: String, password: String, username: String, image: UIImage?, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let image = image else {
                completion(false, "Profile image is required")
                return
            }
            
            self.uploadUserProfileImage(image: image) { imageUrl in
                self.saveUserDetails(userId: authResult?.user.uid, username: username, email: email, imageUrl: imageUrl) { success, message in
                    completion(success, message)
                }
            }
        }
    }
    
    func uploadUserProfileImage(image: UIImage, completion: @escaping (String) -> Void) {
        let imageData: Data
        let contentType: String
        let fileExtension: String
        if let jpegData = image.jpegData(compressionQuality: 0.75) {
            imageData = jpegData
            contentType = "image/jpeg"
            fileExtension = ".jpg"
        } else if let pngData = image.pngData() {
            imageData = pngData
            contentType = "image/png"
            fileExtension = ".png"
        } else {
            completion("")
            return
        }
        
        let imageName = UUID().uuidString + fileExtension
        let metadata = StorageMetadata()
        metadata.contentType = contentType
        let ref = Storage.storage().reference(withPath: "/profile_images/\(imageName)")
        
        ref.putData(imageData, metadata: metadata) { _, error in
            if let error = error {
                print("Failed to upload image: \(error.localizedDescription)")
                completion("")
                return
            }
            
            ref.downloadURL { result in
                switch result {
                case .success(let url):
                    completion(url.absoluteString)
                case .failure(_):
                    completion("")
                }
            }
        }
    }
    
    func saveUserDetails(userId: String?, username: String, email: String, imageUrl: String, completion: @escaping (Bool, String) -> Void) {
        guard let userId = userId else {
            completion(false, "User ID is not available")
            return
        }
        
        let userData = ["username": username, "email": email, "imageUrl": imageUrl]
        Firestore.firestore().collection("users").document(userId).setData(userData) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "User details saved successfully")
            }
        }
    }
    
    func saveUserDetails(userId: String?, username: String, email: String, imageUrl: String, likedThreads: [String] = [], savedThreads: [String] = [], completion: @escaping (Bool, String) -> Void) {
        
        guard let userId = userId else {
            completion(false, "User ID is not available")
            return
        }
        
        let userData: [String: Any] = [
            "username": username,
            "email": email,
            "imageUrl": imageUrl,
            "likedThreads": likedThreads,
            "savedThreads": savedThreads
        ]
        Firestore.firestore().collection("users").document(userId).setData(userData) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "User details saved successfully")
            }
        }
    }
    
    func updateLikedThreads(userId: String, threads: [String], completion: @escaping (Bool, String) -> Void) {
        Firestore.firestore().collection("users").document(userId).updateData(["likedThreads": threads]) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Liked threads updated successfully")
            }
        }
    }
    
    func updateSavedThreads(userId: String, threads: [String], completion: @escaping (Bool, String) -> Void) {
        Firestore.firestore().collection("users").document(userId).updateData(["savedThreads": threads]) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, "Saved threads updated successfully")
            }
        }
    }
    
    func addNewThread(thread: Thread, image: UIImage?, completion: @escaping (Bool, String?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false, "User not authenticated")
            return
        }
        
        var threadData: [String: Any]
        do {
            threadData = try Firestore.Encoder().encode(thread) as! [String: Any]
        } catch {
            completion(false, "Failed to encode thread data")
            return
        }
        
        if let image = image {
            uploadUserProfileImage(image: image) { imageUrl in
                threadData["imageUrl"] = imageUrl
                self.saveThreadData(threadData: threadData, completion: completion)
            }
        } else {
            saveThreadData(threadData: threadData, completion: completion)
        }
    }
    
    private func saveThreadData(threadData: [String: Any], completion: @escaping (Bool, String?) -> Void) {
        Firestore.firestore().collection("threads").addDocument(data: threadData) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchThreads(completion: @escaping ([Thread]) -> Void) {
        Firestore.firestore().collection("threads").order(by: "createdAt", descending: true).getDocuments(source: .server) { snapshot, error in
            if let error = error {
                print("Error fetching threads: \(error)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let threads = documents.compactMap { document -> Thread? in
                try? document.data(as: Thread.self)
            }
            
            completion(threads)
        }
    }
    
    func deleteThread(threadId: String, completion: @escaping (Bool, String?) -> Void) {
        Firestore.firestore().collection("threads").document(threadId).delete { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func updateThread(thread: Thread, image: UIImage?, completion: @escaping (Bool, String?) -> Void) {
        guard let threadId = thread.id else {
            completion(false, "Thread ID not found")
            return
        }
        
        var threadData: [String: Any]
        do {
            threadData = try Firestore.Encoder().encode(thread) as! [String: Any]
        } catch {
            completion(false, "Failed to encode thread data")
            return
        }
        
        if let image = image {
            uploadUserProfileImage(image: image) { imageUrl in
                threadData["imageUrl"] = imageUrl
                self.saveUpdatedThreadData(threadId: threadId, threadData: threadData, completion: completion)
            }
        } else {
            saveUpdatedThreadData(threadId: threadId, threadData: threadData, completion: completion)
        }
    }
    
    private func saveUpdatedThreadData(threadId: String, threadData: [String: Any], completion: @escaping (Bool, String?) -> Void) {
        Firestore.firestore().collection("threads").document(threadId).updateData(threadData) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchComments(threadId: String, completion: @escaping ([Comment]) -> Void) {
        let db = Firestore.firestore()
        let commentsRef = db.collection("threads").document(threadId).collection("comments")
        
        commentsRef.order(by: "timestamp", descending: true).getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching comments: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            let comments = documents.compactMap { document -> Comment? in
                try? document.data(as: Comment.self)
            }
            completion(comments)
        }
    }
    
    
    func addComment(threadId: String, comment: Comment, completion: @escaping (Bool, String?) -> Void) {
        do {
            _ = try db.collection("threads").document(threadId).collection("comments").addDocument(from: comment)
            completion(true, nil)
        } catch {
            completion(false, "Failed to add comment: \(error.localizedDescription)")
        }
    }
    
    func deleteComment(threadId: String, commentId: String, completion: @escaping (Bool, String?) -> Void) {
        db.collection("threads").document(threadId).collection("comments").document(commentId).delete { error in
            if let error = error {
                completion(false, "Failed to delete comment: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchUserData(userId: String, completion: @escaping (User?) -> Void) {
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists {
                let user = try? document.data(as: User.self)
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func toggleLikeThread(threadId: String, userId: String, isLiked: Bool, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let threadRef = db.collection("threads").document(threadId)
        let userRef = db.collection("users").document(userId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let threadDocument: DocumentSnapshot
            let userDocument: DocumentSnapshot
            
            do {
                try threadDocument = transaction.getDocument(threadRef)
                try userDocument = transaction.getDocument(userRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let currentFavoriteCount = threadDocument.data()?["favoriteCount"] as? Int else {
                return nil
            }
            
            var updatedFavoriteCount = currentFavoriteCount
            var updatedLikedThreads = userDocument.data()?["likedThreads"] as? [String] ?? []
            
            if isLiked {
                updatedFavoriteCount -= 1
                if let index = updatedLikedThreads.firstIndex(of: threadId) {
                    updatedLikedThreads.remove(at: index)
                }
            } else {
                updatedFavoriteCount += 1
                updatedLikedThreads.append(threadId)
            }
            
            transaction.updateData(["favoriteCount": updatedFavoriteCount], forDocument: threadRef)
            transaction.updateData(["likedThreads": updatedLikedThreads], forDocument: userRef)
            
            return nil
        }) { (object, error) in
            if let error = error {
                print("Transaction failed: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func toggleSaveThread(threadId: String, userId: String, isSaved: Bool, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "savedThreads": isSaved ? FieldValue.arrayRemove([threadId]) : FieldValue.arrayUnion([threadId])
        ]) { error in
            if let error = error {
                print("Error updating saved threads: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    func fetchSavedThreads(userId: String, completion: @escaping ([Thread]) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if let savedThreadIds = document.data()?["savedThreads"] as? [String] {
                    let threadsRef = db.collection("threads")
                    threadsRef.whereField(FieldPath.documentID(), in: savedThreadIds).getDocuments { snapshot, error in
                        guard let documents = snapshot?.documents else {
                            print("Error fetching saved threads: \(error?.localizedDescription ?? "Unknown error")")
                            completion([])
                            return
                        }
                        let threads = documents.compactMap { try? $0.data(as: Thread.self) }
                        completion(threads)
                    }
                } else {
                    completion([])
                }
            } else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
            }
        }
    }
}
