//
//  CardButtons.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import FirebaseFirestore

struct CardButtons: View {
    var threadId: String
    var userId: String
    var isLiked: Bool
    var isSaved: Bool
    var onLike: () -> Void
    var onSave: () -> Void
    var color: Color = .white
    @Binding var favoriteCount: Int

    var body: some View {
        HStack {
            Spacer()
            HStack(spacing: 10) {
                HStack(spacing: 5) {
                    Text("\(favoriteCount)")
                        .font(.headline)
                    Button(action: {
                        onLike()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(color)
                            .fontWeight(.medium)
                            .font(.system(size: 23))
                    }
                }
                Button(action: {
                    onSave()
                }) {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .foregroundColor(color)
                        .fontWeight(.medium)
                        .font(.system(size: 23))
                }
            }
            .padding(.top, 15)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    CardButtons(threadId: "sampleThreadId", userId: "sampleUserId", isLiked: false, isSaved: false, onLike: {}, onSave: {}, favoriteCount: .constant(0))
        .background(Color.blue)
}


