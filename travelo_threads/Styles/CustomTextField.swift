//
//  CustomTextField.swift
//  AnimatedApp
//
//  Created by Meng To on 2022-04-11.
//

import SwiftUI

struct CustomTextField: ViewModifier {
    var image: Image?
    var backgroundColor: Color = .white
    var borderColor: Color = Color.black.opacity(0.1)
    var cornerRadius: CGFloat = 10

    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.leading, image != nil ? 40 : 15) // Adjust padding if image is present
            .background(backgroundColor)
            .mask(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous).stroke(borderColor, lineWidth: 1))
            .overlay(
                HStack {
                    if let image = image {
                        image
                            .padding(.leading, 8)
                        Spacer()
                    }
                }
            )
    }
}

extension View {
    func customTextField(image: Image? = nil, backgroundColor: Color = .white, borderColor: Color = Color.black.opacity(0.1), cornerRadius: CGFloat = 10) -> some View {
        modifier(CustomTextField(image: image, backgroundColor: backgroundColor, borderColor: borderColor, cornerRadius: cornerRadius))
    }
}
