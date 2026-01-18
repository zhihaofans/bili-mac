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
        VStack(spacing: 0) {
            UserProfileHeaderView()
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
                                    .onTapGesture {
                                        SU.log.i("=============================")
                                        SU.log.i("History.unsupported type tapped:")
                                        print(video)
                                    }
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
                        date: item.pubdate.pastTimeString,
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
                    var cover = item.cover
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
                    case "article-list":
                        durationData = "专栏"
                        cover = item.covers?.first ?? "https://i0.hdslb.com/bfs/archive/1d40e975b09d5c87b11b3ae0c9ce6c6b82f63d9e.png"
                    case "live":
                        playData = (item.live_status == 1).string("直播中", "未开播")
                        danmakuData = item.tag_name!
                        durationData = "直播"
                        url = item.uri!
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

struct UserProfileHeaderView: View {
    @State private var userName: String = "加载中…"
    @State private var userNameColor: String = "#FB7299"
    @State private var userFace: String = "https://i0.hdslb.com/bfs/face/demo.jpg"
    @State private var userLV: String = "LV9999"
    @State private var userSign: String = "并没有签名"
    @State private var vipTitle: String = "叔叔送的年度大会员"
    @State private var coins: Double = -1
    @State private var following: Int = -1
    @State private var fans: Int = -1

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                // 头像
                AsyncImage(url: URL(string: userFace)) { img in
                    img.resizable().scaledToFill()
                } placeholder: {
                    Circle().fill(Color.gray.opacity(0.3))
                }
                .frame(width: 64, height: 64)
                .clipShape(Circle())

                // 名字 & 状态
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        Text(userName)
                            .foregroundColor(Color(hex: userNameColor /* "#FB7299" */ ))
                            .font(.system(size: 18, weight: .semibold))

                        Text(userLV)
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.pink.opacity(0.2))
                            .cornerRadius(4)

                        Text(vipTitle)
                            .font(.system(size: 11))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }

                    Text(userSign)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // 右侧统计
                HStack(spacing: 32) {
                    ProfileStatView(title: "硬币", value: String(coins))
                    ProfileStatView(title: "关注", value: following.toString)
                    ProfileStatView(title: "粉丝", value: fans.toString)
                }

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(nsColor: .windowBackgroundColor))
                    .opacity(0.9)
            )
        }.onAppear {
            UserService().getUserSpaceInfo { data in
                userName = data.name
                userFace = data.face
                userSign = data.sign
                userLV = "LV\(data.level)"
                userNameColor = data.vip.nickname_color.isEmpty ? "#FB7299" : data.vip.nickname_color
                coins = data.coins
                following = data.following
                fans = data.follower
                if data.vip.status == 1 {
                    vipTitle = data.vip.label.text
                } else {
                    vipTitle = "不是大会员"
                }
            } fail: { errStr in
                userName = errStr
                SU.log.e(errStr)
            }
        }
    }
}

struct ProfileStatView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .semibold))
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}
