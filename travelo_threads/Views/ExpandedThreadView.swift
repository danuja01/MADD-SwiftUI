//
//  ExpandedThreadView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct ExpandedThreadView: View {
    @StateObject private var userImageLoader = ImageLoader()
    @StateObject private var sectionImageLoader = ImageLoader()
    @StateObject private var locationFetcher = LocationFetcher()
    
    var section: Thread
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            CloseButton(action: {
                self.presentationMode.wrappedValue.dismiss()
            })
            
            ScrollView {
                VStack(spacing: 20) {
                    SharedThreadContent(
                        userImageLoader: userImageLoader,
                        sectionImageLoader: sectionImageLoader,
                        locationFetcher: locationFetcher,
                        section: section,
                        showCaption: true,
                        buttonColor: Color("Button")
                    )
                    content
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .overlay(
                    CardButtons(color: Color("Button")).padding(.top, 10),
                    alignment: .topTrailing
                )
                .cornerRadius(30)
            }
        }
        .background(Color("Background"))
        .statusBar(hidden: true)
    }
    
    var content: some View {
        VStack(spacing: 20){
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("Green2"))
        CommentTextArea()
            
        }
    }
    
}

#Preview {
    ExpandedThreadView(section: sampleThreads[2])
}
