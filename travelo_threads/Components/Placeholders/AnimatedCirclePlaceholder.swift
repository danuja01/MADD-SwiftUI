//
//  AnimatedCirclePlaceholder.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct AnimatedCirclePlaceholder: View {
    var body: some View {
        Circle()
            .foregroundColor(Color("Placeholder"))
            .frame(width: 50, height: 50)
            .animatePlaceholder()
    }
}

#Preview {
    AnimatedCirclePlaceholder()
}
