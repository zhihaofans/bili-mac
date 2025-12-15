//
//  UserView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//

import SwiftUI

struct UserView: View {
    @State private var selected: HomeTopTab = .recommend
    @State private var videos: [VideoItem] = []
    @State private var errorStr: String = "欢迎使用 BBMac - 加载中..."
    var body: some View {
        Text("这里加个人资料")
        VStack(spacing: 0) {
            HStack(spacing: 30) {
                ForEach(HomeTopTab.allCases, id: \.self) { tab in
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
            ScrollView {
                if !errorStr.isEmpty {
                    Text(errorStr)
                        .font(.headline)
                        .padding(.top, 20)
                }

                if videos.isEmpty {
                    VStack {
                        ProgressView("加载中…")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding(.top, 50)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                } else {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 260), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(videos) { video in
                            VideoCard(video: video)
                                .contextMenu {
                                    Text(video.bvid)
                                }
                        }
                    }
                    .padding(20)
                }
            }
        }.onAppear {
//            loadVideos(for: selected)
        }.onChange(of: selected) { _, newTab in
            errorStr = "加载中..."
            videos.removeAll()
//            loadVideos(for: newTab)
        }
        .navigationTitle("个人 - BBMac")
    }
    
    private func loadCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videos = Array(repeating: MockData.videos, count: 3).flatMap { $0 }
//            errorStr = "已显示缓存"
        }
    }
}
