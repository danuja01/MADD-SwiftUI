//
//  UserView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-12.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @EnvironmentObject var threadsViewModel: ThreadsViewModel
    @State private var myThreads: [Thread] = []
    @StateObject private var userImageLoader = ImageLoader()
    @State private var selectedThread: Thread?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 20) {
                    if let imageUrl = authManager.userImageURL {
                        UserImage(userImageLoader: userImageLoader, imageUrl: imageUrl, size: 70)
                    }
                    VStack(alignment: .leading) {
                        Text(authManager.userName ?? "Unknown User")
                            .font(.title.bold())
                        Text(authManager.userEmail ?? "Unknown Email")
                            .foregroundColor(Color("Green1"))
                            .foregroundColor(.black) // Change the color of email text
                    }
                }.padding(.bottom, 20)
                
                Button(action: {
                    authManager.signOut()
                }) {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .foregroundColor(.white.opacity(0.8))
                            .bold()
                        Spacer()
                    }
                    .padding(.vertical, 7)
                    .background(Color("Green4"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("Green1"), lineWidth: 1)
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                    
                Text("My Threads")
                    .font(.title2.bold())
                
                if myThreads.isEmpty {
                    Text("No threads published yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 20)
                } else {
                    ForEach(myThreads) { thread in
                        ThreadCard(
                            section: thread,
                            onDelete: {
                                threadsViewModel.deleteThread(thread) { success, message in
                                    if success {
                                        fetchMyThreads()
                                    }
                                }
                            },
                            onEdit: {
                                // Handle edit
                            },
                            onTap: {
                                selectedThread = thread
                            },
                            onToggleSave: {
                                // Handle save toggle
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 15)
        }
        .onAppear {
            fetchMyThreads()
        }
        .fullScreenCover(item: $selectedThread) { thread in
            ExpandedThreadView(section: thread)
        }
    }
    
    func fetchMyThreads() {
        guard let userId = authManager.currentUserId else { return }
        let allThreads = threadsViewModel.threads
        myThreads = allThreads.filter { $0.createdBy == userId }
    }
}

#Preview {
    UserView()
        .environmentObject(AuthenticationManager())
        .environmentObject(ThreadsViewModel())
}

