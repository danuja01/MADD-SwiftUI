//
//  HomeView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct HomeView: View {
    @State private var tabBarHeight: CGFloat = 0
    @State private var selectedThread: Thread?
    @State private var threads: [Thread] = []

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .refreshable {
                fetchThreads()
            }
            .onAppear(perform: fetchThreads)
            .onPreferenceChange(TabBarHeightPreferenceKey.self) { value in
                tabBarHeight = value
            }
            .fullScreenCover(item: $selectedThread) { thread in
                ExpandedThreadView(section: thread)
            }.navigationTitle("Threads")
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(threads) { thread in
                Button(action: {
                    selectedThread = thread
                }) {
                    ThreadCard(section: thread)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .padding(.bottom, tabBarHeight + 50)
    }

    func fetchThreads() {
        FirebaseManager.shared.fetchThreads { fetchedThreads in
            threads = fetchedThreads
        }
    }
}

#Preview {
    HomeView()
}

