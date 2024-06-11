//
//  ContentView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @EnvironmentObject var userAuth: AuthenticationManager
    @State private var isAddNewThreadPresented = false
    @StateObject private var threadsViewModel = ThreadsViewModel()

    var body: some View {
        ZStack {
            if userAuth.isAuthenticated {
                authenticatedView
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    .environmentObject(threadsViewModel)
            } else {
                SignIn()
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            }
        }
        .animation(.default, value: userAuth.isAuthenticated)
        .ignoresSafeArea()
    }

    @ViewBuilder
    private var authenticatedView: some View {
        NavigationView {
            switch selectedTab {
            case .home:
                HomeView()
                    .frame(maxHeight: .infinity)
                    .environmentObject(threadsViewModel)
            case .save:
                Text("Save View")
            case .user:
                Text("User View")
            default:
                EmptyView()
            }
        }
        .sheet(isPresented: $isAddNewThreadPresented) {
            AddNewThreadView { newThread, image in
                threadsViewModel.addThread(newThread, image: image) { success, message in
                    if success {
                        isAddNewThreadPresented = false
                    } else {
                        // Handle error
                    }
                }
            }
        }

        TabBar(isAddNewThreadPresented: $isAddNewThreadPresented)
            .padding(.bottom, 20)
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthenticationManager())
}
