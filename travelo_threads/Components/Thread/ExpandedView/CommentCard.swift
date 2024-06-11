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
                
                // Only show the delete button if the current user created the comment
                if section.createdBy == currentUserId, let onDelete = onDelete {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
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
    CommentCard(section: sampleComments[2], onDelete: nil, currentUserId: "currentUserId")
        .padding()
}
