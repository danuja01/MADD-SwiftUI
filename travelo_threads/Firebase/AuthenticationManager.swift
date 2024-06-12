//
//  AuthenticationManager.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import Combine
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var userName: String? = nil {
        didSet {
            print("userName updated to: \(userName ?? "nil")")
        }
    }
    @Published var userImageURL: String? = nil {
        didSet {
            print("userImageURL updated to: \(userImageURL ?? "nil")")
        }
    }
    @Published var userEmail: String? = nil
    var currentUserId: String? {
        Auth.auth().currentUser?.uid
    }

    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }

            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.userEmail = email
            }
            
            if let userID = authResult?.user.uid {
                self.fetchUserDetails(userId: userID)
            }
            completion(true, "")
        }
    }

    func fetchUserDetails(userId: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userId)

        docRef.getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                DispatchQueue.main.async {
                    self?.userName = data?["username"] as? String
                    self?.userImageURL = data?["imageUrl"] as? String
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            userName = nil
            userImageURL = nil
            userEmail = nil
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
