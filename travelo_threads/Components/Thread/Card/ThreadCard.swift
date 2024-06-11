//
//  ThreadCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import FirebaseAuth

struct ThreadCard: View {
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    
    var section: Thread
    var onDelete: () -> Void
    var onEdit: () -> Void
    var onTap: () -> Void
    var forceReload: Bool = false

    var body: some View {
        VStack {
            SharedThreadContent(
                userImageLoader: userImageLoader,
                sectionImageLoader: sectionImageLoader,
                locationFetcher: locationFetcher,
                section: section,
                showCaption: true,
                buttonColor: .white,
                forceReload: forceReload
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
        .onTapGesture {
            onTap()
        }
        .contextMenu {
            if section.createdBy == Auth.auth().currentUser?.uid {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                }
                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                }
            } else {
                Button(action: {}) {
                    Label("Cannot edit or delete this thread", systemImage: "xmark.octagon")
                }
                .disabled(true)
            }
        }
        .onAppear {
            // Reload images and location on appear
            if let imageUrl = section.imageUrl, let url = URL(string: imageUrl) {
                sectionImageLoader.load(url: url, forceReload: forceReload)
            }
            if let location = section.location {
                locationFetcher.fetchLocation(for: location.toCLLocationCoordinate2D(), forceReload: forceReload)
            }
        }
    }
}

#Preview {
    ThreadCard(section: sampleThreads[0], onDelete: {}, onEdit: {}, onTap: {}).padding()
}

