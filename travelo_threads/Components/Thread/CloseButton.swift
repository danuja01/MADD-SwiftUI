//
//  CloseButton.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CloseButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Image(systemName: "xmark")
                    .foregroundColor(Color.white.opacity(0.8))
            }
            .frame(width: 30, height: 30)
            .background(Circle().foregroundColor(Color.black.opacity(0.6)))
            .padding(.trailing, 20)
            .padding(.top, -20)
        }
    }
}

#Preview {
    CloseButton(action: { print("button pressed") })
}
