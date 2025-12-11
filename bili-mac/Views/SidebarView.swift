//
//  SidebarView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import SwiftUI



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
