//
//  Training.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-07.
//

import SwiftUI

struct Training: View {
    @Namespace var namespace
    @State var show = false
    
    var body: some View {
        VStack{
            SignIn()
        }
    }
}

#Preview {
    Training()
}
