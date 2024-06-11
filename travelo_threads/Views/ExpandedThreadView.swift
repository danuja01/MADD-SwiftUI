//
//  ExpandedThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import FirebaseAuth

struct ExpandedThreadView: View {
    @FocusState private var isFocused: Bool
    @State private var commentText: String = ""
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    @State private var comments: [Comment] = []

    var section: Thread
    
    @EnvironmentObject var authManager: AuthenticationManager
    @Environment(\.presentationMode) var presentationMode
    
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
                    CardButtons(color: Color("Button")).padding(.top, 0),
                    alignment: .topTrailing
                )
                .cornerRadius(30)
            }.scrollIndicators(.never)
        }
        .background(Color("Background"))
        .statusBar(hidden: true)
        .onAppear {
            fetchComments()
        }
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
                ForEach(comments) { comment in
                    CommentCard(section: comment, onDelete: {
                        deleteComment(comment)
                    }, currentUserId: Auth.auth().currentUser?.uid ?? "")
                }
            }
        }
    }
    
    func fetchComments() {
        FirebaseManager.shared.fetchComments(threadId: section.id ?? "") { fetchedComments in
            comments = fetchedComments
        }
    }
    
    func addComment() {
        guard let user = Auth.auth().currentUser else { return }
        let newComment = Comment(
            text: commentText,
            createdBy: user.uid,
            userName: authManager.userName ?? "Anonymous",
            userImage: authManager.userImageURL ?? ""
        )
        
        FirebaseManager.shared.addComment(threadId: section.id ?? "", comment: newComment) { success, error in
            if success {
                fetchComments()
                commentText = ""
                isFocused = false
            } else {
                print("Error adding comment: \(error ?? "Unknown error")")
            }
        }
    }
    
    func deleteComment(_ comment: Comment) {
        FirebaseManager.shared.deleteComment(threadId: section.id ?? "", commentId: comment.id ?? "") { success, error in
            if success {
                fetchComments()
            } else {
                print("Error deleting comment: \(error ?? "Unknown error")")
            }
        }
    }
}

#Preview {
    ExpandedThreadView(section: sampleThreads[1])
        .environmentObject(AuthenticationManager())
}
