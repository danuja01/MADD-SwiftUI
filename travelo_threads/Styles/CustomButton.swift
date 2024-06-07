//
//  CustomButton.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct CustomButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .padding(.horizontal, 8)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundStyle(.primary)
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func customButton() -> some View {
        modifier(CustomButton())
    }
}

struct LargeButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color("Green1"))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20))
            .shadow(color: Color(hex: "000000").opacity(0.2), radius: 20, x: 0, y: 5)
    }
}

extension View {
    func largeButton() -> some View {
        modifier(LargeButton())
    }
}
