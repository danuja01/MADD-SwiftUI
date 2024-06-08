//
//  CommentTextArea.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CommentTextArea: View {
    @State private var comment: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("Green3")
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color("Green1"), lineWidth: 2)
                )
            
            TextEditor(text: $comment)
                .focused($isFocused)
                .lineSpacing(10.0)
                .lineLimit(10...)
                .scrollContentBackground(.hidden)
                .background(Color("Green3"))
                .cornerRadius(30)
                .padding()
            
            if comment.isEmpty && !isFocused {
                HStack {
                    Image("Icon Comment")
                    Text("Comment")
                        .foregroundColor(Color.gray)
                        .fontWeight(.bold)
                }
                .padding()
            }
        }
        .frame(height: 120)
    }
}

#Preview {
    CommentTextArea().padding()

}

