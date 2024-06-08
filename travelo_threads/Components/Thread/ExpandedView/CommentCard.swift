//
//  CommentCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-08.
//

import SwiftUI

struct CommentCard: View {
    @StateObject private var userImageLoader = ImageLoader()
    
    var section:Comment
     var userImageSize: CGFloat = 35

    var body: some View {
        VStack{
            HStack(alignment:.top, spacing: 15){
                UserImage(userImageLoader: userImageLoader, imageUrl: section.userImage, size: userImageSize)
                VStack(alignment: .leading){
                    Text(section.userName)
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("This is Awesome I want to go again!")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color("CommentBoxText"))
        .background(Color("CommentBox"))
        .cornerRadius(30)
    }
}

#Preview {
    CommentCard(section: sampleComments[2]).padding()

}
