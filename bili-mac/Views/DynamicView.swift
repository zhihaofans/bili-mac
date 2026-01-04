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
    var body: some View {
        VStack(spacing: 0) {
            DynamicTopBarView(selected: selected) // tab + 搜索

            Divider()

            DynamicFeedView(selected: selected) // 动态流
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .setNavigationTitle("动态")
    }
}

struct DynamicTopBarView: View {
    @State var selected: DynamicTopTab = .all

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
            TextField("搜索你感兴趣的动态", text: .constant(""))
                .textFieldStyle(.roundedBorder)
                .frame(width: 240)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }
}

struct DynamicFeedView: View {
    @State var selected: DynamicTopTab = .all
    @State private var dynamicList: [DynamicListItem] = []
    @State private var errorStr: String = ""
    @State private var isLoading: Bool = true
    @State private var isError: Bool = false
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
                        ForEach(dynamicList, id: \.id) { item in
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
        if item.isSupported{
                switch DynamicType(rawValue: item.type) {
                default:
                    EmptyView()
                }
        }else{
            Text("⚠️ 暂不支持此动态类型：\(item.typeName)")
                .font(.headline)
                .foregroundColor(.red)
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
