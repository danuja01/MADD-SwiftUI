//
//  CustomTextArea.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CustomTextArea: View {
    @Binding var text: String
    var placeholder: String
    var height: CGFloat = 120
    var maxLength: Int = 200
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("CommentArea")
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(text.count > maxLength ? Color.red : Color("Green1"), lineWidth: 1)
                )
            
            TextEditor(text: $text)
                .focused($isFocused)
                .lineSpacing(10.0)
                .scrollContentBackground(.hidden)
                .background(Color("CommentArea"))
                .padding()
                .padding(.bottom, 20)
                .autocorrectionDisabled()
                .onChange(of: text) { newValue in
                    if newValue.count > maxLength {
                        text = String(newValue.prefix(maxLength))
                    }
                }
            
            if text.isEmpty && !isFocused {
                HStack {
                    Image("Icon Comment")
                    Text(placeholder)
                        .foregroundColor(Color("Green2").opacity(0.6))
                }
                .padding(.vertical)
                .padding(.horizontal, 12)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("\(text.count)/\(maxLength)")
                        .foregroundColor(text.count > maxLength ? Color.red : Color("Green2").opacity(0.6))
                        .padding([.bottom], 10)
                        .padding(.trailing, 15)
                }
            }
        }
        .frame(height: height)
    }
}

#Preview {
    CustomTextArea(text: .constant(""), placeholder: "Go ahead, tell us more!")
        .padding()
}

