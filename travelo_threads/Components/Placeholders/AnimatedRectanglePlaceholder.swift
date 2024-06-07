//
//  AnimatedRectanglePlaceholder.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct AnimatedRectanglePlaceholder: View {
    var body: some View {
        Rectangle()
            .frame(height: 180)
            .foregroundColor(Color("Placeholder"))
            .cornerRadius(30)
            .animatePlaceholder()
    }
}

#Preview {
    AnimatedRectanglePlaceholder().padding()
}
