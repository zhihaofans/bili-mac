//
//  ContentView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/10.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedSidebar: SidebarItem? = .home
    var body: some View {
        NavigationSplitView {
            SidebarView(selected: $selectedSidebar)
        } detail: {
            switch selectedSidebar {
            case .home:
                HomeView()
                    .background(Color(NSColor.windowBackgroundColor)) // 自动适配亮/暗
            case .featured:
                Text("Hello, 精选!")
            case .dynamic:
                Text("Hello, 动态!")
            case .mine:
                Text("Hello, mine!")
            case .setting:
//                Text("Hello, 设置!")
                SettingView()
            case nil:
                Text("Hello, nil!")
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}
