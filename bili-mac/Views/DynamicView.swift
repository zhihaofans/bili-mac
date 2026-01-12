//
//  DynamicView.swift
//  bili-mac
//
//  Created by zzh on 2026/1/2.
//

import SwiftUI
import SwiftUtils

struct DynamicView: View {
    @State private var selected: DynamicTopTab = .all
    @State private var searchKey: String = ""
    var body: some View {
        VStack(spacing: 0) {
            DynamicTopBarView(selected: selected, searchKey: $searchKey) // tab + 搜索

            Divider()

            DynamicFeedView(selected: selected, searchKey: $searchKey) // 动态流
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .setNavigationTitle("动态")
    }
}

struct DynamicTopBarView: View {
    @State var selected: DynamicTopTab = .all

    @Binding var searchKey: String
    var body: some View {
        HStack {
            ForEach(DynamicTopTab.allCases, id: \.self) { tab in
                Text(tab.rawValue)
                    .foregroundColor(selected == tab ? .primary : .secondary)
                    .font(.system(size: 15, weight: .medium))
                    .padding(.vertical, 10)
                    .onTapGesture { selected = tab }
            }
            Spacer()

            // 搜索
            TextField("搜索你感兴趣的动态", text: $searchKey)
                .textFieldStyle(.roundedBorder)
                .frame(width: 240)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

struct DynamicFeedView: View {
    @State var selected: DynamicTopTab = .all
    @Binding var searchKey: String
    @State private var dynamicList: [DynamicListItem] = []
    @State private var errorStr: String = ""
    @State private var isLoading: Bool = true
    @State private var isError: Bool = false
    private var filteredList: [DynamicListItem] {
        guard !searchKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return dynamicList
        }
        return dynamicList.filter { item in
            let key = searchKey.lowercased()
            let title = (item.title ?? "").lowercased()
            let desc = (item.desc ?? "").lowercased()
            let author = item.authorName.lowercased()
            let type = item.typeName.lowercased()
            let majorType = (item.majorType?.text ?? "").lowercased()
            return title.contains(key)
                || desc.contains(key)
                || author.contains(key)
                || type.contains(key)
                || majorType.contains(key)
        }
    }

    var body: some View {
        ScrollView {
            HStack {
                Spacer(minLength: 0)
                if isLoading {
                    Text("加载中…")
                        .font(.headline)
                        .padding(.top, 20)
                } else if isError {
                    Text("⚠️加载失败:\(errorStr)")
                        .font(.headline)
                        .padding(.top, 20)
                } else {
                    VStack(spacing: 16) {
                        ForEach(filteredList, id: \.id) { item in
                            DynamicCardView(item: item)
                        }
                    }
                    .frame(maxWidth: 720) // ⭐ 控制内容宽度
                    .padding(.vertical, 20)
                }

                Spacer(minLength: 0)
            }
        }
        .task {
            self.loadVideos(for: selected)
        }
    }

    private func loadCache() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dynamicList = []
            isLoading = false
            isError = true
        }
    }

    private func loadVideos(for tab: DynamicTopTab) {
        let failure: (String) -> Void = { err in
            errorStr = err
            loadCache()
        }

        // 🔥 Tab → 接口分发（关键修改点）
        switch tab {
        case .all:
            let success: (DynamicListData) -> Void = { data in
                guard let list = data.items, !list.isEmpty else {
                    errorStr = "空白结果"
                    loadCache()
                    return
                }
                dynamicList = list
                isLoading = false
                isError = false
            }
            DynamicService().getDynamicList(callback: success, fail: failure)
        default:
            loadCache()
        }
    }
}

struct DynamicCardView: View {
    let item: DynamicListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DynamicHeaderView(item: item)

            DynamicContentView(item: item) // ⭐ 内容分发

//            DynamicFooterView(item: item)
        }
        .padding(16)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
        .shadow(
            color: Color.black.opacity(0.15),
            radius: 8,
            x: 0,
            y: 4
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.04), lineWidth: 1)
        )
    }
}

struct DynamicHeaderView: View {
    let item: DynamicListItem

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            // 头像
            AvatarView(url: item.authorface.httpToHttps)
                .id(item.authorface.httpToHttps)
                .frame(width: 40, height: 40)

            // 用户名 + 时间 / 类型
            VStack(alignment: .leading, spacing: 4) {
                Text(item.authorName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)

                HStack(spacing: 6) {
                    Text(item.pushTime)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)

                    Text("·")

                    Text(item.typeName)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .onClick {
                            print(item)
                        }
                }
            }

            Spacer()

            // 更多按钮
            Button {
                // TODO: more action
                print(item)
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
}

struct DynamicContentView: View {
    let item: DynamicListItem

    var body: some View {
        if item.isSupported {
            switch DynamicType(rawValue: item.type) {
            case .av:
                NavigationLink {
                    VideoDetailView(
                        bvid: item.modules.dynamic.major?.archive?.bvid ?? ""
                    )
                } label: {
                    DynamicVideoItemView(item: item)
                }
                .buttonStyle(.plain)
            case .draw:
                DynamicVideoItemView(item: item)
            case .word:
                DynamicVideoItemView(item: item)
            case .liveRcmd:
                DynamicVideoItemView(item: item)
            default:
                EmptyView()
            }
        } else if item.majorType != nil {
            Text("⚠️ 暂不支持此动态类型：\(item.majorType!.rawValue)")
                .font(.headline)
                .foregroundColor(.red)
                .onClick {
                    print(item)
                }
        } else {
            Text("⚠️ 暂不支持此动态类型：\(item.typeName)")
                .font(.headline)
                .foregroundColor(.red)
                .onClick {
                    print(item)
                }
        }
    }
}

struct DynamicVideoItemView: View {
    let item: DynamicListItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 标题
            Text(item.title ?? item.desc ?? "「没有标题」")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(5)
            if item.images.count > 1 {
                // 多图九宫格
                DynamicImageGridView(pics: item.images)
            } else if item.cover.isNotEmpty {
                // 视频封面
                VideoCoverView(item: item)
            }
        }.onAppear {
            print("jsonData")
            print(item.modules.dynamic.major?.live_rcmd?.content)
        }
    }
}

struct VideoCoverView: View {
    let item: DynamicListItem
    @State private var aspectRatio: CGFloat = 16.0 / 9.0
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: item.cover!.httpToHttps)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(aspectRatio, contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 360)
                    .clipped()
                    .cornerRadius(10)
            } placeholder: {
                Color.gray.opacity(0.25)
            }
            .contextMenu {
                ImageMenu(img: item.cover!.httpToHttps)
            }
            if item.type == DynamicType.av.rawValue {
                // 左下角：播放量
                HStack(spacing: 8) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))

                    Text(item.modules.dynamic.major?.archive?.stat.play ?? "0")
                        .font(.system(size: 12))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.black.opacity(0.6))
                .cornerRadius(6)
                .foregroundColor(.white)
                .padding(8)

                // 右下角：时长
                HStack {
                    Spacer()

                    Text(item.modules.dynamic.major?.archive?.duration_text ?? "时长")
                        .font(.system(size: 12))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(.black.opacity(0.6))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                        .padding(8)
                }
            }
        }.onAppear {
            if let pic = item.modules.dynamic.major?.opus?.pics.first,
               pic.width > 0,
               pic.height > 0
            {
                aspectRatio = CGFloat(pic.width / pic.height)
            }
        }
    }
}

// 九宫格图片视图
struct DynamicImageGridView: View {
    let pics: [ModuleDynamicMajorOpusPics]

    private let size: CGFloat = 120
    private let spacing: CGFloat = 6

    private let columns = Array(
        repeating: GridItem(.fixed(120), spacing: 6),
        count: 3
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(pics.prefix(9), id: \.url) { pic in
                AsyncImage(url: URL(string: pic.url.httpToHttps)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.25)
                }
                .frame(width: size, height: size)
                .clipped()
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.primary.opacity(0.12), lineWidth: 0.5)
                )
                .contextMenu {
                    ImageMenu(img: pic.url.httpToHttps)
                }
            }
        }
    }
}

struct AvatarView: View {
    let url: String

    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .clipShape(Circle())
    }
}

struct TabItem: View {
    let title: String
    let selected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: selected ? .semibold : .regular))
                .foregroundColor(selected ? .biliPink : .secondary)

            Rectangle()
                .fill(selected ? Color.biliPink : Color.clear)
                .frame(height: 2)
        }
    }
}

enum DynamicTopTab: String, CaseIterable {
    case all = "所有"
    case video = "视频"
}
