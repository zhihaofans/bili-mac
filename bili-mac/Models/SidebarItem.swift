//
//  SidebarItem.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

enum SidebarItem: String, CaseIterable, Hashable, Identifiable {
    case home = "首页"
    case featured = "热门精选"
    case dynamic = "动态"
    case mine = "我的"
    case setting = "设置"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home: return "house"
        case .featured: return "flame.fill"
        case .dynamic: return "bolt"
        case .mine: return "person"
        case .setting: return "gear"

        }
    }
}
