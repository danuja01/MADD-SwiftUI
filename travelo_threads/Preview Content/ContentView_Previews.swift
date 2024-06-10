//
//  ContentView_Previews.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-10.
//

import SwiftUI

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(previewAuthManager(authenticated: false))
                .previewDisplayName("Logged Out")

            ContentView()
                .environmentObject(previewAuthManager(authenticated: true))
                .previewDisplayName("Logged In")
        }
    }

    static func previewAuthManager(authenticated: Bool) -> AuthenticationManager {
        let manager = AuthenticationManager()
        manager.isAuthenticated = authenticated
        return manager
    }
}

