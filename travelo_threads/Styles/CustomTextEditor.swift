//
//  CustomTextEditor.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CustomTextEditor: ViewModifier {
    var image: Image
    
    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.leading, 36)
            .background(Color("Green1"))
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color("Green2"), lineWidth: 1))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
    }
}

extension View {
    func customTextEditor(image: Image) -> some View {
        modifier(CustomTextEditor(image: image))
    }
}
