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
    @EnvironmentObject var threadsViewModel: ThreadsViewModel
    @State private var isPresentingAddNewThread = false
    @State private var threadToEdit: Thread?

    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            ScrollView {
                content
            }
            .scrollIndicators(.never)
            .refreshable {
                threadsViewModel.fetchThreads()
            }
            .onAppear {
                threadsViewModel.fetchThreads()
            }
            .onPreferenceChange(TabBarHeightPreferenceKey.self) { value in
                tabBarHeight = value
            }
            .fullScreenCover(item: $selectedThread) { thread in
                ExpandedThreadView(section: thread)
            }
            .sheet(isPresented: $isPresentingAddNewThread, onDismiss: {
                threadsViewModel.fetchThreads()
            }) {
                AddNewThreadView { newThread, image in
                    threadsViewModel.addThread(newThread, image: image) { success, message in
                        if success {
                            isPresentingAddNewThread = false
                        }
                    }
                }
            }
            .sheet(item: $threadToEdit, onDismiss: {
                threadsViewModel.fetchThreads()
            }) { thread in
                EditThreadView(thread: thread) { updatedThread in
                    updateThread(updatedThread)
                }
            }
            .navigationTitle("Threads")
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(threadsViewModel.threads) { thread in
                ThreadCard(section: thread, onDelete: {
                    withAnimation {
                        threadsViewModel.deleteThread(thread) { success, message in
                            if !success {
                               
                            }
                        }
                    }
                }, onEdit: {
                    threadToEdit = thread
                }, onTap: {
                    selectedThread = thread
                }, onToggleSave: {
                    threadsViewModel.toggleSaveThread(thread, isSaved: false) { success in
                        if success {
                            threadsViewModel.fetchThreads()
                        }
                    }
                })
                .buttonStyle(PlainButtonStyle())
                .onLongPressGesture {
                    if thread.createdBy == Auth.auth().currentUser?.uid {
                        threadToEdit = thread
                    }
                }
            }
        }
        .padding()
        .padding(.bottom, tabBarHeight + 50)
    }

    private func updateThread(_ updatedThread: Thread) {
        guard let index = threadsViewModel.threads.firstIndex(where: { $0.id == updatedThread.id }) else { return }
        threadsViewModel.threads[index] = updatedThread
    }
}

#Preview {
    HomeView()
        .environmentObject(ThreadsViewModel())
}
