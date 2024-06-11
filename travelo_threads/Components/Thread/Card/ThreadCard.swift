//
//  ThreadCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ThreadCard: View {
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    @StateObject private var threadActionsViewModel: ThreadActionsViewModel

    var section: Thread
    var onDelete: () -> Void
    var onEdit: () -> Void
    var onTap: () -> Void
    var forceReload: Bool = false

    init(section: Thread, onDelete: @escaping () -> Void, onEdit: @escaping () -> Void, onTap: @escaping () -> Void) {
        self.section = section
        self.onDelete = onDelete
        self.onEdit = onEdit
        self.onTap = onTap
        self._threadActionsViewModel = StateObject(wrappedValue: ThreadActionsViewModel(thread: section, userId: Auth.auth().currentUser?.uid ?? ""))
    }
    
    @EnvironmentObject var authManager: AuthenticationManager

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
        .padding(.top, 10)
        .overlay(
            CardButtons(
                threadId: section.id ?? "",
                userId: Auth.auth().currentUser?.uid ?? "",
                isLiked: threadActionsViewModel.isLiked,
                isSaved: threadActionsViewModel.isSaved,
                onLike: {
                    threadActionsViewModel.toggleLike()
                },
                onSave: {
                    threadActionsViewModel.toggleSave()
                },
                color: .white,
                favoriteCount: $threadActionsViewModel.favoriteCount
            )
            .environmentObject(authManager)
            .padding(.top, 0),
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
            if let imageUrl = section.imageUrl, let url = URL(string: imageUrl) {
                sectionImageLoader.load(url: url, forceReload: forceReload)
            }
            if let location = section.location {
                locationFetcher.fetchLocation(for: location.toCLLocationCoordinate2D(), forceReload: forceReload)
            }
            threadActionsViewModel.fetchUserData()
            threadActionsViewModel.fetchFavoriteCount()
        }
    }
}

#Preview {
    ThreadCard(section: sampleThreads[1], onDelete: {}, onEdit: {}, onTap: {})
        .environmentObject(AuthenticationManager())
}
