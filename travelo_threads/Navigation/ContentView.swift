//
//  ContentView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    @State private var isAddNewThreadPresented = false

    var body: some View {
        ZStack {
            NavigationView {
                switch selectedTab {
                case .home:
                    HomeView()
                        .frame(maxHeight: .infinity)
                case .save:
                    Text("Save View")
                case .user:
                    Text("User View")
                default:
                    EmptyView()
                }
            }
            .sheet(isPresented: $isAddNewThreadPresented) {
                AddNewThread()
            }

            TabBar(isAddNewThreadPresented: $isAddNewThreadPresented)
                .padding(.bottom, 20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
