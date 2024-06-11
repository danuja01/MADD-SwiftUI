//
//  CardButtons.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct CardButtons: View {
    var color: Color = .white
    var body: some View {
            HStack {
                Spacer()
                HStack(spacing: 10) {
                    HStack(spacing: 5){
                        Text("20")
                            .foregroundColor(color)
                        Button(action: {
                            // Action for the heart button
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(color)
                                .fontWeight(.medium)
                                .font(.system(size: 23))
                        }
                    }
                    Button(action: {
                        // Action for the bookmark button
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(color)
                            .fontWeight(.medium)
                            .font(.system(size: 23))
                    }
                }
                .padding(.top, 15)
                .padding(.trailing, 20)
            }
            Spacer()
        }
}

#Preview {
    CardButtons().background(.blue)
}
