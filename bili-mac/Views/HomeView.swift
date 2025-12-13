//
//  HomeView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import SwiftUI
import SwiftUtils

struct HomeView: View {
    @State private var videos: [VideoItem] = []
    @State private var errorStr: String = "欢迎使用 BBMac - 加载中..."

    var body: some View {
        VStack(spacing: 0) {
            HomeTopTabBar()
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
                        }
                    }
                    .padding(20)
                }
            }
        }.onAppear {
            loadVideos()
        }
    }

    private func loadCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videos = Array(repeating: MockData.videos, count: 3).flatMap { $0 }
//            errorStr = "已显示缓存"
        }
    }

    private func loadVideos() {
        RankService().getHomePage { result in
//            DispatchQueue.main.async {
            if result.code != 0 {
                errorStr = "code(\(result.code)):\(result.message)"
                loadCache()
            } else if result.data == nil {
                errorStr = "result.data = nil"
                loadCache()
            } else if result.data!.list.isEmpty {
                errorStr = "空白热门榜"
                loadCache()
            } else {
                if let list = result.data?.list, !list.isEmpty {
                    videos = list.map { item in
                        VideoItem(
                            cover: item.pic,
                            title: item.title,
                            play: formatPlayCount(item.stat.view),
                            danmaku: formatPlayCount(item.stat.danmaku),
                            duration: formatDuration(item.duration),
                            author_name: item.owner.name,
                            author_face: item.owner.face,
                            date: item.pubdate.toString
                        )
                    }
                    errorStr = ""
                } else {
                    loadCache()
                }
            }
//            }
        } fail: { err in
            DispatchQueue.main.async {
                loadCache()
                errorStr = err
            }
        }
    }

    func formatDuration(_ seconds: Int) -> String {
        // 秒数转成文本时间（最大到小时）
        guard seconds > 0 else { return "0秒" }

        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60

        if hour > 0 {
            return String(format: "%d:%02d:%02d", hour, minute, second)
        } else {
            return String(format: "%d:%02d", minute, second)
        }
    }

    func formatPlayCount(_ count: Int) -> String {
        // 视频弹幕、播放数字格式化
        if count < 10_000 {
            return "\(count)"
        } else {
            let value = Double(count) / 10_000
            return String(format: "%.1f万", value)
                .replacingOccurrences(of: ".0", with: "")
        }
    }
}

struct HomeTopTabBar: View {
    @State private var selected: HomeTopTab = .recommend

    var body: some View {
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
        .navigationTitle("首页 - BBMac")
    }
}

enum HomeTopTab: String, CaseIterable {
    case recommend = "推荐"
    case hot = "热门"
    case follow = "追番"
    case movie = "影视"
}
