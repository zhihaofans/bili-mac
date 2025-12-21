//
//  UserView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//

import SwiftUI
import SwiftUtils

struct UserView: View {
    @State private var selected: UserTopTab = .later2watch
    @State private var videos: [VideoItem] = []
    @State private var errorStr: String = "欢迎使用 BBMac - 加载中..."
    var body: some View {
        Text("这里加个人资料")
        VStack(spacing: 0) {
            HStack(spacing: 30) {
                ForEach(UserTopTab.allCases, id: \.self) { tab in
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
                            if video.bvid.isEmpty {
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

                                        Button("打开UP空间") {
                                            // TODO: 打开UP空间
                                        }.disabled(true)
                                    }
                            } else {
                                NavigationLink(value: HomeRoute.video(bvid: video.bvid)) {
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

                                            Button("打开UP空间") {
                                                // TODO: 打开UP空间
                                            }.disabled(true)
                                        }
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
        .navigationDestination(for: HomeRoute.self) { route in
            switch route {
            case .video(let bvid):
                VideoDetailView(bvid: bvid)
            }
        }
        .navigationTitle("我的 - BBMac")
    }

    private func loadCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            videos = Array(repeating: MockData.videos, count: 3).flatMap { $0 }
//            errorStr = "已显示缓存"
        }
    }

    private func loadVideos(for tab: UserTopTab) {
        let failure: (String) -> Void = { err in
            errorStr = err
            loadCache()
        }

        // 🔥 Tab → 接口分发（关键修改点）
        switch tab {
        case .later2watch:
            let success: (LaterWatchListData) -> Void = { data in
                guard let list = data.list, !list.isEmpty else {
                    errorStr = "空白结果"
                    loadCache()
                    return
                }

                videos = list.map { item in
                    VideoItem(
                        cover: item.pic,
                        title: item.title,
                        play: item.stat.view.toShortNumberString,
                        danmaku: item.stat.danmaku.toShortNumberString,
                        duration: item.duration.toShortNumberString,
                        author_name: item.owner.name,
                        author_face: item.owner.face,
                        date: item.pubdate.toString,
                        url: item.uri, // ?? "https://www.bilibili.com/video/${item.bvid}",
                        bvid: item.bvid
                    )
                }

                errorStr = ""
            }
            LaterToWatchService().getList(callback: success, fail: failure)
        case .history:
            let success: (HistoryListData) -> Void = { data in
                guard let list = data.list, !list.isEmpty else {
                    errorStr = "空白结果"
                    loadCache()
                    return
                }

                videos = list.map { item in
                    let history = item.history
                    var url = ""
                    var playData = "..."
                    var cover = item.cover // TODO: 专栏时改为item.covers[0]
                    var durationData = "..."
                    var danmakuData = "..."
                    switch history.business {
                    case "archive":
                        // 投稿视频
                        url = "https://www.bilibili.com/video/${business.oid}"
                        durationData = item.duration!.secondsToTimeLongString
                        danmakuData = item.tag_name!
                        if item.progress == 0 {
                            playData = "还没看"
                        } else if item.progress == item.duration {
                            playData = "已看完"
                        } else {
                            let percent = Double(item.progress!) / Double(item.duration!) * 100
                            playData = String(format: "%.2f%%", percent)
                        }
                    case "pgc":
                        url = item.uri!
                        durationData = item.duration!.secondsToTimeLongString
                        danmakuData = (item.is_finish == 1).string("已完结", "未完结")
                        if item.progress == 0 {
                            playData = "还没看"
                        } else if item.progress == item.duration {
                            playData = "已看完"
                        } else {
                            let percent = Double(item.progress!) / Double(item.duration!) * 100
                            playData = String(format: "%.2f%%", percent)
                        }
                    default:
                        url = ""
                    }
                    return VideoItem(
                        cover: cover,
                        title: item.title,
                        play: playData,
                        danmaku: danmakuData,
                        duration: durationData,
                        author_name: item.author_name,
                        author_face: item.author_face,
                        date: item.view_at.pastTimeString + "观看",
                        url: url,
                        bvid: item.history.bvid ?? ""
                    )
                }

                errorStr = ""
            }
            HistoryService().getList(callback: success, fail: failure)
        default:
            errorStr = "暂未实现"
            loadCache()
        }
    }
}

enum UserTopTab: String, CaseIterable {
    case later2watch = "稍后再看"
    case history = "历史"
    case favorite = "收藏夹"
}
