//
//  CommentTextArea.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CommentTextArea: View {
    @Binding var comment: String
    @FocusState private var isFocused: Bool
    var onCommit: () -> Void

    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("CommentArea")
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("Green1"), lineWidth: 2)
                )

            TextEditor(text: $comment)
                .focused($isFocused)
                .lineSpacing(10.0)
                .scrollContentBackground(.hidden)
                .background(Color("CommentArea"))
                .padding()
                .autocorrectionDisabled()
                .onSubmit {
                    onCommit()
                }

            if comment.isEmpty && !isFocused {
                HStack {
                    Image("Icon Comment")
                    Text("Comment")
                        .foregroundColor(Color("Green2").opacity(0.6))
                        .fontWeight(.bold)
                }
                .padding()
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Circle()
                            .fill(Color.gray.opacity(0.3))  // Opacity background
                            .frame(width: 40, height: 40)
                            .overlay(
                                Button(action: {
                                    onCommit()
                                }) {
                                    Image(systemName: "paperplane.fill")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            )
                            .padding()
                    }
                }
            }
        }
        .frame(height: 120)
    }
}

#Preview {
    CommentTextArea(comment: Binding.constant(""), onCommit: {})
        .padding()
}
