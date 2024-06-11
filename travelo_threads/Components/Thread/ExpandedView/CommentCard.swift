//
//  CommentCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CommentCard: View {
    @StateObject private var userImageLoader = ImageLoader()
    
    var section: Comment
    var userImageSize: CGFloat = 35
    var onDelete: (() -> Void)? = nil
    var currentUserId: String
    
    @State private var showAlert = false

    var body: some View {
        VStack {
            HStack(alignment:.top, spacing: 15) {
                UserImage(userImageLoader: userImageLoader, imageUrl: section.userImage, size: userImageSize)
                VStack(alignment: .leading) {
                    Text(section.userName)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(section.text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                
                if section.createdBy == currentUserId, let onDelete = onDelete {
                    Button(action: {
                        showAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(Color(hex:"#FFF7F1"))
                            .fontWeight(.semibold)
                            .font(.system(size: 18))
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Delete Comment"),
                            message: Text("Are you sure you want to delete this comment?"),
                            primaryButton: .destructive(Text("Delete")) {
                                onDelete()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color("CommentBoxText"))
        .background(Color("CommentBox"))
        .cornerRadius(30)
    }
}

#Preview {
    CommentCard(section: sampleComments[0], onDelete: nil, currentUserId: "currentUserId")
        .padding()
}
