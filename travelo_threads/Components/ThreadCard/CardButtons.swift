//
//  CardButtons.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct CardButtons: View {
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Button(action: {
                    // Action for the heart button
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
                Button(action: {
                    // Action for the bookmark button
                }) {
                    Image(systemName: "bookmark")
                        .foregroundColor(.white)
                        .fontWeight(.medium)
                }
            }
            .padding(.top, 15)
            .padding(.trailing, 20)
        }
    }
}

#Preview {
    CardButtons()
}
