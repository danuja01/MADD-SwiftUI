//
//  TabBar.swift
//  travelo_threads
//
//  Created by Danuja Jayasuriya on 2024-06-06.
//

import SwiftUI
import RiveRuntime

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .home
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                content
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color(.black).opacity(0.8))
            .background(.ultraThinMaterial)
            .mask(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color("Background 2").opacity(0.3), radius: 20, x: 0, y: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(.linearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .padding(.horizontal, 24)
            .background(GeometryReader { geometry in
                           Color.clear.preference(key: TabBarHeightPreferenceKey.self, value: geometry.size.height)
                       })
        }
    }
    
    var content: some View {
        ForEach(tabItems) { item in
            Button {
                try? item.icon.setInput("active", value: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    try? item.icon.setInput("active", value: false)
                }
                withAnimation {
                    selectedTab = item.tab
                }
            } label: {
                item.icon.view()
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)
                    .opacity(selectedTab == item.tab ? 1 : 0.5)
                    .background(
                        VStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: selectedTab == item.tab ? 20 : 0, height: 4)
                                .offset(y: -4)
                                .opacity(selectedTab == item.tab ? 1 : 0)
                                .foregroundColor(Color("Green1"))
                            Spacer()
                        }
                    )
            }
        }
    }
}

struct TabBarHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct TabItem: Identifiable {
    var id = UUID()
    var icon: RiveViewModel
    var tab: Tab
}

var tabItems = [
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"), tab: .home),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "PLUS_Interactivity", artboardName: "PLUS"), tab: .add),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "BOOKMARK_Interactivity", artboardName: "BOOKMARK"), tab: .save),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "USER_Interactivity", artboardName: "USER"), tab: .user)
    
]

enum Tab: String {
    case home, add, save, user
}
