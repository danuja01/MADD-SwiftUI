//
//  UserImage.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//
import SwiftUI

struct UserImage: View {
    @ObservedObject var userImageLoader: ImageLoader
    var imageUrl: String
    var size: CGFloat
  
    var body: some View {
        if let image = userImageLoader.image {
            Circle()
                .frame(width: size, height: size)
                .overlay(
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaledToFill()
                        .clipShape(Circle())
                )
                .shadow(color: Color("Shadow").opacity(0.1), radius: 10, x: 0, y: 0)
        } else {
            Circle()
                .frame(width: size, height: size)
                .animatePlaceholder()
                .shadow(color: Color("Shadow").opacity(0.1), radius: 10, x: 0, y: 0)
                .onAppear {
                    if let url = URL(string: imageUrl) {
                        userImageLoader.load(url: url)
                    }
                }
        }
    }
}

#Preview {
    UserImage(userImageLoader: ImageLoader(), imageUrl: sampleThreads[0].userImage, size: 50)
}
