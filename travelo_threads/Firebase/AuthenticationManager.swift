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

class AuthenticationManager: ObservableObject {
    @Published var isAuthenticated = false
    
    func signIn(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                }
                completion(true, "")
            }
        }

        func signOut() {
            do {
                try Auth.auth().signOut()
                isAuthenticated = false
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
}
 
