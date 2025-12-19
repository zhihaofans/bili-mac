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
            NavigationStack {
                switch selectedSidebar {
                case .home:
                    HomeView()
//            case .dynamic:
//                Text("Hello, 动态!")
                case .mine:
                    UserView()
                case .setting:
                    SettingView()
                default:
                    Text("Hello, nil!")
                }
            }
        }
        .navigationSplitViewStyle(.prominentDetail)
    }
}
