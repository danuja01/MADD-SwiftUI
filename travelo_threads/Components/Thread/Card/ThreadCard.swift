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
    @State private var isLiked: Bool = false
    @State private var isSaved: Bool = false
    
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
                isLiked: isLiked,
                isSaved: isSaved,
                onLike: {
                    toggleLike()
                },
                onSave: {
                    toggleSave()
                },
                color: .white
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
            fetchUserData()
        }
    }
    
    func fetchUserData() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.fetchUserData(userId: userId) { user in
            guard let user = user else { return }
            isLiked = user.likedThreads.contains(section.id ?? "")
            isSaved = user.savedThreads.contains(section.id ?? "")
        }
    }
    
    func toggleLike() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.toggleLikeThread(threadId: section.id ?? "", userId: userId, isLiked: isLiked) { success in
            if success {
                isLiked.toggle()
            }
        }
    }
    
    func toggleSave() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        FirebaseManager.shared.toggleSaveThread(threadId: section.id ?? "", userId: userId, isSaved: isSaved) { success in
            if success {
                isSaved.toggle()
            }
        }
    }
}


#Preview {
    ExpandedThreadView(section: sampleThreads[1])
        .environmentObject(AuthenticationManager())
}
