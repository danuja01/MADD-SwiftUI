//
//  HomeView.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()

            ScrollView {
                content
            }
        }
        .navigationTitle("Threads")
    }
    
    
    var content: some View {
        VStack(alignment:.leading , spacing: 20) {
            ForEach(sampleThreads) { section in
                    ThreadCard(section: section)
            }
        }.padding()
            .padding(.bottom, 40)
           
    }
}

#Preview {
    HomeView()
}
