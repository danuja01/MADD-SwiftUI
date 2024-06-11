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
            db.collection("threads").document(threadId).collection("comments")
                .order(by: "timestamp", descending: false)
                .getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching comments: \(error)")
                        completion([])
                    } else {
                        let comments = snapshot?.documents.compactMap { try? $0.data(as: Comment.self) } ?? []
                        completion(comments)
                    }
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
}
