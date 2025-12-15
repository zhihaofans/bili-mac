//
//  HomeView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import SwiftUtils

struct HomeView: View {
    @State private var selected: HomeTopTab = .recommend
    @State private var videos: [VideoItem] = []
    @State private var errorStr: String = "欢迎使用 BBMac - 加载中..."
    var body: some View {
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

                                    Button("复制链接") {
                                        ClipboardUtil().setString(video.url)
                                    }
                                    Button("复制标题") {
                                        ClipboardUtil().setString(video.title)
                                    }
                                    Divider()
                                    Button("添加到稍后再看") {
                                        // TODO: 添加稍后再看功能
                                    }
                                    Button("打开UP空间") {
                                        // TODO: 打开UP空间
                                    }
                                }
                        }
                    }
                    .padding(20)
                }
            }
        }.onAppear {
            loadVideos(for: selected)
        }.onChange(of: selected) { _, newTab in
            errorStr = "加载中..."
            videos.removeAll()
            loadVideos(for: newTab)
        }
        .navigationTitle("首页 - BBMac")
    }

    private func loadCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videos = Array(repeating: MockData.videos, count: 3).flatMap { $0 }
//            errorStr = "已显示缓存"
        }
    }

    private func loadVideos(for tab: HomeTopTab) {
        let rankService = RankService()

        let success: (BiliRankResult) -> Void = { result in
            if result.code != 0 {
                errorStr = "code(\(result.code)):\(result.message)"
                loadCache()
                return
            }

            guard let list = result.data?.list, !list.isEmpty else {
                errorStr = "空白热门榜"
                loadCache()
                return
            }

            videos = list.map { item in
                VideoItem(
                    cover: item.pic,
                    title: item.title,
                    play: NumberUtil().formatPlayCount(item.stat.view),
                    danmaku: NumberUtil().formatPlayCount(item.stat.danmaku),
                    duration: NumberUtil().formatDuration(item.duration),
                    author_name: item.owner.name,
                    author_face: item.owner.face,
                    date: item.pubdate.toString,
                    url: item.short_link_v2 ?? "https://www.bilibili.com/video/${item.bvid}",
                    bvid: item.bvid
                )
            }

            errorStr = ""
        }

        let failure: (String) -> Void = { err in
            errorStr = err
            loadCache()
        }

        // 🔥 Tab → 接口分发（关键修改点）
        switch tab {
        case .recommend:
            rankService.getHomePage(callback: success, fail: failure)

        case .topRanking:
            rankService.getTopRanking(callback: success, fail: failure)

        case .follow:
            errorStr = "追番暂未实现"
            loadCache()

        case .movie:
            errorStr = "影视暂未实现"
            loadCache()
        }
    }
}

enum HomeTopTab: String, CaseIterable {
    case recommend = "推荐"
    case topRanking = "排行榜"
    case follow = "追番"
    case movie = "影视"
}
