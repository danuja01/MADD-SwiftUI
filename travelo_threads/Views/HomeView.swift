//
//  HomeView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var tabBarHeight: CGFloat = 0
    @State private var selectedThread: Thread?
    @State private var threads: [Thread] = []
    @State private var isPresentingAddNewThread = false

    // Use an optional Thread for editing
    @State private var threadToEdit: Thread?

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
            }
            .sheet(isPresented: $isPresentingAddNewThread, onDismiss: fetchThreads) {
                AddNewThreadView()
            }
            .sheet(item: $threadToEdit, onDismiss: fetchThreads) { thread in
                EditThreadView(thread: thread) { updatedThread in
                    updateThread(updatedThread)
                }
            }
            .navigationTitle("Threads")
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(threads) { thread in
                ThreadCard(section: thread, onDelete: {
                    deleteThread(thread)
                }, onEdit: {
                    threadToEdit = thread
                }, onTap: {
                    selectedThread = thread
                })
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture {
                    if thread.createdBy == Auth.auth().currentUser?.uid {
                        threadToEdit = thread
                    } else {
                        // Handle other actions for threads not created by the current user
                    }
                }
            }
        }
        .padding()
        .padding(.bottom, tabBarHeight + 50)
    }

    private func updateThread(_ updatedThread: Thread) {
        guard let index = threads.firstIndex(where: { $0.id == updatedThread.id }) else { return }
        threads[index] = updatedThread
    }

    func fetchThreads() {
        FirebaseManager.shared.fetchThreads { fetchedThreads in
            DispatchQueue.main.async {
                threads = fetchedThreads
            }
        }
    }

    func deleteThread(_ thread: Thread) {
        guard let threadId = thread.id else { return }
        FirebaseManager.shared.deleteThread(threadId: threadId) { success, message in
            if success {
                fetchThreads()
            } else {
                // Show alert or handle error
                print("Failed to delete thread: \(message ?? "Unknown error")")
            }
        }
    }
}

#Preview {
    HomeView()
}
