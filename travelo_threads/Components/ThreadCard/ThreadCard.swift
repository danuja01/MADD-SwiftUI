//
//  ThreadCard.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct ThreadCard: View {
    var section = sampleThreads[0]
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image("User")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaledToFill()
                            .clipShape(Circle())
                    )
                    .shadow(color: Color("Shadow").opacity(0.2), radius: 10, x: 0, y: 0)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Thomas Edwin")
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Way to Sigiriya")
                        .font(.system(size: 24, weight: .bold))
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                
            }.padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Lats day I wen to Sigiriya with my friends and it was and unbelievable construction on a Rock!!")
                    .font(.system(size: 17))
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 20))
                    Text("Sigiriya, Sri Lanka")
                        .font(.system(size: 13, weight: .semibold))
                }
            }
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
    ThreadCard().padding()
}
