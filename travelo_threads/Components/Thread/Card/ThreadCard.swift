//
//  ThreadCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct ThreadCard: View {
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    
    var section: Thread

    var body: some View {
        VStack {
            SharedThreadContent(
                userImageLoader: userImageLoader,
                sectionImageLoader: sectionImageLoader,
                locationFetcher: locationFetcher,
                section: section,
                showCaption: true,
                buttonColor: .white
            )
        }
        .padding()
        .padding(.vertical, 10)
        .overlay(
            CardButtons(),
            alignment: .topTrailing
        )
        .foregroundColor(.white)
        .background(Color("Green1"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

#Preview {
    ThreadCard(section: sampleThreads[0]).padding()
}

