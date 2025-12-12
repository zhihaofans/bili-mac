//
//  HomeView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 0) {
            TopTabBar()
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                    ForEach(MockData.videos) { video in
                        VideoCard(video: video)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct TopTabBar: View {
    @State private var selected: TopTab = .recommend

    var body: some View {
        HStack(spacing: 30) {
            ForEach(TopTab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .foregroundColor(selected == tab ? .primary : .secondary)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.vertical, 10)
                    .onTapGesture { selected = tab }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(.thickMaterial) // 自动随系统变化
    }
}

enum TopTab: String, CaseIterable {
    case recommend = "推荐"
    case hot = "热门"
    case follow = "追番"
    case movie = "影视"
}
