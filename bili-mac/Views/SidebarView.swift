//
//  SidebarView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import SwiftUI

enum SidebarItem: String, CaseIterable, Hashable, Identifiable {
    case home = "首页"
    case dynamic = "动态"
    case mine = "我的"
    case setting = "设置"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house"
        case .dynamic: return "bolt"
        case .mine: return "person"
        case .setting: return "gear"
        }
    }
}

struct SidebarView: View {
    @Binding var selected: SidebarItem?

    var body: some View {
        List(SidebarItem.allCases, selection: $selected) { item in
            Label(item.rawValue, systemImage: item.icon)
                .tag(item)
        }
        .listStyle(.sidebar)
    }
}
