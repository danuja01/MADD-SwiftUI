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
    @State private var isExpanded = false
    @Namespace private var animation

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            if !isExpanded {
                ScrollView {
                    content
                }
                .navigationTitle("Threads")
                .onPreferenceChange(TabBarHeightPreferenceKey.self) { value in
                    tabBarHeight = value
                }
            }

            if isExpanded, let selectedThread = selectedThread {
                ExpandedThreadView(isExpanded: $isExpanded, section: selectedThread, animation: animation)
                    .background(
                        Color.black.opacity(0.5)
                            .ignoresSafeArea()
                    )
                    .onDisappear {
                        isExpanded = false
                    }
            }
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(sampleThreads) { section in
                ThreadCard(section: section, animation: animation, isExpanded: $isExpanded)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            selectedThread = section
                            isExpanded = true
                        }
                    }
            }
        }
        .padding()
        .padding(.bottom, tabBarHeight + 50)
    }
}

#Preview {
    HomeView()
}
