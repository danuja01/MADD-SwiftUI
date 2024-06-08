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
    
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .refreshable {
//                impliment refreshhh!!
            }
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
            ForEach(sampleThreads) { section in
                Button(action: {
                    selectedThread = section
                }) {
                    ThreadCard(section: section)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
        .padding(.bottom, tabBarHeight + 50)
    }
}

#Preview {
    HomeView()
}

