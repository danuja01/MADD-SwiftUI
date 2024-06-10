//
//  travelo_threadsApp.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

@main
struct travelo_threadsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authenticationManager = AuthenticationManager()  // Create an instance of UserAuth

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticationManager)  // Provide the environment object
        }
    }
}

