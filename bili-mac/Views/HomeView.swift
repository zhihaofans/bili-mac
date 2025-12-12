//
//  HomeView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import SwiftUI

struct HomeView: View {
    @State private var videos: [VideoItem] = []

    var body: some View {
        VStack(spacing: 0) {
            TopTabBar()
            ScrollView {
                if videos.isEmpty {
                    VStack {
                        ProgressView("加载中…")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    GeometryReader { geo in
                        let width = geo.size.width
                        let itemWidth: CGFloat = 260
                        let spacing: CGFloat = 16
                        let columns = max(Int(width / (itemWidth + spacing)), 1)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
                                  spacing: spacing)
                        {
                            ForEach(videos) { video in
                                VideoCard(video: video)
                            }
                        }
                        .padding(20)
                    }
                }
            }
        }.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                videos = Array(repeating: MockData.videos, count: 3).flatMap { $0 }
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
