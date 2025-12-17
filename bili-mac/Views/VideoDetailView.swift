//
//  VideoDetailView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//
import SwiftUI
import SwiftUtils

struct VideoDetailView: View {
    let bvid: String

    @State private var info: BiliVideoInfoData
    @State private var errorStr: String = "加载中…"
    init(bvid: String) {
        self.bvid = bvid
        self.info = BiliVideoInfoData(
            bvid: "BV1xx411c7mD",
            aid: 123456789,
            videos: 1,
            pic: "https://i0.hdslb.com/bfs/archive/mock.jpg",
            cover43: nil,
            title: "这是一个示例视频标题（Mock Data）",
            pubdate: 1700000000,
            ctime: 1700000000,
            desc: "这是视频简介的 mock 内容，用于在未接入接口前调试布局。支持多行文本展示，长度可以随意加长。",
            duration: 360,
            owner: BiliVideoInfoOwner(
                mid: 987654321,
                name: "测试UP主",
                face: "https://i0.hdslb.com/bfs/face/mock.jpg"
            ),
            tname: "科技",
            dynamic: "这是动态内容",
            no_cache: false,
            pages: [
            ],
            short_link_v2: "https://b23.tv/xxxxxx",
            stat: BiliVideoStat(aid: 0, view: 0, danmaku: 0, reply: 0, favorite: 0, coin: 0, share: 0, nowRank: 0, hisRank: 0, like: 0, dislike: 0, evaluation: "", vt: 0)
        )
        self.errorStr = "loading..."
    }

    var body: some View {
        GeometryReader { geo in
            let isCompact = geo.size.width < 900

            if isCompact {
                // MARK: - 窄窗口：纵向布局（类似手机）

                ScrollView {
                    VStack(spacing: 0) {
                        // 封面 / 播放区域
                        VideoCoverView(coverURL: info.pic)
                        // 视频信息
                        contentView
                            .padding(.top, 12)
                    }
                }
            } else {
                // MARK: - 宽窗口：左右分栏布局（桌面）

                HStack(spacing: 0) {
                    // 左侧：播放器区
                    VideoCoverView(coverURL: info.pic)
                        .padding(24)
                        .frame(minWidth: 520)
                        .frame(maxWidth: .infinity)
                        .background(Color.black)

                    Divider()

                    contentView
                        .frame(width: 360)
                }
            }
        }
        .onAppear {
            loadVideoDetail()
        }
        .navigationTitle("视频详情：" + bvid)
    }

    private func loadVideoDetail() {
        Task {
            VideoService().getVideoDetail(bvid: bvid) { data in
                DispatchQueue.main.async {
                    // 成功
                    info = data
                }
            } fail: { errStr in
                DispatchQueue.main.async {
                    errorStr = "加载失败:\(errStr)"
                }
            }
        }
    }

    private struct VideoCoverView: View {
        let coverURL: String
        init(coverURL: String) {
            self.coverURL = coverURL.httpToHttps
        }

        var body: some View {
            ZStack {
                Color.black

                AsyncImage(url: URL(string: coverURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.25))
                }
                .aspectRatio(16 / 9, contentMode: .fit)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(.white.opacity(0.85))
                )
                .padding()
            }
            .contextMenu {
                Button("复制封面链接") {
                    ClipboardUtil().setString(coverURL)
                }
                Button("复制封面图片") {
//                    ClipboardUtil().setImage()
                }.disabled(true)
            }
        }
    }

    private var contentView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(info.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fixedSize(horizontal: false, vertical: true)

                Text("BV号：\(info.bvid) · 发布时间：\(info.pubdate)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack(spacing: 14) {
                    Label(NumberUtil().formatPlayCount(info.stat.view), systemImage: "play.fill")
                    Label(NumberUtil().formatPlayCount(info.stat.danmaku), systemImage: "text.bubble")
                    Label(NumberUtil().formatPlayCount(info.stat.like), systemImage: "hand.thumbsup.fill")
                    Label(NumberUtil().formatPlayCount(info.stat.favorite), systemImage: "star.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)

                Divider()

                HStack(spacing: 12) {
                    Button("稍后再看") {}
                    Button("收藏") {}
                    Button("投币") {}
                    Button("分享") {}
                }
                .buttonStyle(.bordered)

                Divider()

                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: info.owner.face)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                    }
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .contextMenu {
                        Button("复制头像链接") {
                            ClipboardUtil().setString(info.owner.face)
                        }
                        Button("复制头像图片") {
                            // ClipboardUtil().setImage()
                        }.disabled(true)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(info.owner.name)
                            .font(.headline)
                        Text(info.owner.mid.toString)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button("已关注") {}
                        .buttonStyle(.bordered)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("简介")
                        .font(.headline)

                    Text(info.desc)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                Spacer(minLength: 40)
            }
            .padding(20)
            Divider()

            VideoQRCodeView(
                url: info.short_link_v2 ?? "https://www.bilibili.com/video/\(info.bvid)"
            )
        }
    }

    private struct VideoQRCodeView: View {
        let url: String

        var body: some View {
            VStack(spacing: 12) {
                Text("手机扫码观看")
                    .font(.headline)

                Image(nsImage: generateQRCode(from: url))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 160, height: 160)

                Text("使用哔哩哔哩 App 扫码打开")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }

        private func generateQRCode(from string: String, size: CGFloat = 160) -> NSImage {
            let context = CIContext()
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(string.utf8)

            // 兜底占位图（灰色方块）
            let placeholder = NSImage(size: NSSize(width: size, height: size))
            placeholder.lockFocus()
            NSColor.systemGray.withAlphaComponent(0.3).setFill()
            NSBezierPath(rect: NSRect(x: 0, y: 0, width: size, height: size)).fill()
            placeholder.unlockFocus()

            guard let outputImage = filter.outputImage else {
                return placeholder
            }

            let scaleX = size / outputImage.extent.width
            let scaleY = size / outputImage.extent.height
            let transformed = outputImage.transformed(
                by: CGAffineTransform(scaleX: scaleX, y: scaleY)
            )

            guard let cgimg = context.createCGImage(transformed, from: transformed.extent) else {
                return placeholder
            }

            return NSImage(
                cgImage: cgimg,
                size: NSSize(width: size, height: size)
            )
        }
    }
}
