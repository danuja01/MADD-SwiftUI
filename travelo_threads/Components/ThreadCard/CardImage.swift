//
//  CardImage.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct CardImage: View {
    var body: some View {
        Rectangle()
            .frame(width: .infinity, height: 180)
            .overlay(
                Image("Sigiriya")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaledToFill()
                    .clipShape(Rectangle())
            )
            .cornerRadius(30)
            .shadow(color: Color("Shadow").opacity(0.25), radius: 30, x: 0, y: 2)
    }
}

#Preview {
    CardImage().padding()
}
