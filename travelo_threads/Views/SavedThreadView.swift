//
//  SavedThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SavedThreadView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var threadsViewModel: ThreadsViewModel

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    threadsViewModel.fetchSavedThreads(userId: userId)
                }
            }
        }
        .navigationTitle("Saved Threads")
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            if threadsViewModel.savedThreads.isEmpty {
                Text("No saved threads")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ForEach(threadsViewModel.savedThreads) { thread in
                    ThreadCard(section: thread, onDelete: {
                        withAnimation {
                            threadsViewModel.deleteThread(thread) { success, message in
                                if success {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        threadsViewModel.fetchSavedThreads(userId: userId)
                                    }
                                }
                            }
                        }
                    }, onEdit: {
                        // Handle edit
                    }, onTap: {
                        // Handle tap
                    }, onToggleSave: {
                        withAnimation {
                            threadsViewModel.toggleSaveThread(thread, isSaved: true) { success in
                                if success {
                                    if let userId = Auth.auth().currentUser?.uid {
                                        threadsViewModel.fetchSavedThreads(userId: userId)
                                    }
                                }
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding()
    }
}

#Preview {
    SavedThreadView()
        .environmentObject(AuthenticationManager())
        .environmentObject(ThreadsViewModel())
}
