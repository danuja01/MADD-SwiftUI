//
//  ExpandedThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ExpandedThreadView: View {
    @FocusState private var isFocused: Bool
    @State private var commentText: String = ""
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    @StateObject private var commentsViewModel: CommentsViewModel
    @StateObject private var threadActionsViewModel: ThreadActionsViewModel

    var section: Thread
    
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.presentationMode) var presentationMode

    init(section: Thread) {
        self.section = section
        self._commentsViewModel = StateObject(wrappedValue: CommentsViewModel(threadId: section.id ?? ""))
        self._threadActionsViewModel = StateObject(wrappedValue: ThreadActionsViewModel(thread: section, userId: Auth.auth().currentUser?.uid ?? ""))
    }

    var body: some View {
        VStack {
            CloseButton(action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            ScrollView {
                VStack(spacing: 20) {
                    SharedThreadContent(
                        userImageLoader: userImageLoader,
                        sectionImageLoader: sectionImageLoader,
                        locationFetcher: locationFetcher,
                        section: section,
                        showCaption: true,
                        buttonColor: Color("Button")
                    )
                    commentSection
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .padding(.top, 10)
                .overlay(
                    CardButtons(
                        threadId: section.id ?? "",
                        userId: Auth.auth().currentUser?.uid ?? "",
                        isLiked: threadActionsViewModel.isLiked,
                        isSaved: threadActionsViewModel.isSaved,
                        onLike: {
                            threadActionsViewModel.toggleLike()
                        },
                        onSave: {
                            threadActionsViewModel.toggleSave()
                        },
                        color: Color("Button"),
                        favoriteCount: $threadActionsViewModel.favoriteCount
                    )
                    .environmentObject(authManager)
                    .padding(.top, 0),
                    alignment: .topTrailing
                )
                .cornerRadius(30)
            }.scrollIndicators(.never)
        }
        .background(Color("Background"))
        .statusBar(hidden: true)
        .onTapGesture {
            isFocused = false
        }
    }
    
    var commentSection: some View {
        VStack(spacing: 20) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("Green2"))
            
            CommentTextArea(comment: $commentText, onCommit: addComment)
                .focused($isFocused)
            
            VStack(spacing: 10) {
                ForEach(commentsViewModel.comments) { comment in
                    CommentCard(section: comment, onDelete: {
                        commentsViewModel.deleteComment(comment)
                    }, currentUserId: Auth.auth().currentUser?.uid ?? "")
                }
            }
        }
    }
    
    func addComment() {
        guard let user = Auth.auth().currentUser else { return }
        commentsViewModel.addComment(
            text: commentText,
            userName: authManager.userName ?? "Anonymous",
            userImage: authManager.userImageURL ?? "",
            userId: user.uid
        )
        commentText = ""
        isFocused = false
    }
}

#Preview {
    ExpandedThreadView(section: sampleThreads[1])
        .environmentObject(AuthenticationManager())
}
