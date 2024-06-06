//
//  ContentView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home

    var body: some View {
        ZStack() {
            NavigationView {
                    switch selectedTab {
                    case .home:
                        HomeView()
                            .frame(maxHeight: .infinity)
                    case .add:
                        Text("Add View")
                    case .save:
                        Text("Save View")
                    case .user:
                        Text("User View")
                    }
            }
            TabBar()
        }
//        .ignoresSafeArea(.keyboard)
    }
}


#Preview {
    ContentView()
}
