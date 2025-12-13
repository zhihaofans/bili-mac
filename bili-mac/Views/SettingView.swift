//
//  SettingView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/12.
//

import SwiftUI

struct SettingView: View {
    @AppStorage(SettingsKeys.auth_accesskey) private var accesskey: String = ""
    @AppStorage(SettingsKeys.auth_cookie) private var cookie: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                sectionHeader("登录哔哩哔哩你可以")

                HStack(spacing: 20) {
                    FeatureTag(name: "免费观看高清视频", systemImage: "play.rectangle")
                    FeatureTag(name: "多端同步播放记录", systemImage: "arrow.triangle.2.circlepath")
                    FeatureTag(name: "发送弹幕/评论", systemImage: "bubble.left")
                    FeatureTag(name: "热门番剧影视看不停", systemImage: "film")
                }

                Button("立即登录") {}
                    .buttonStyle(PinkRoundedButton())

                sectionHeader("登录数据")

                VStack(alignment: .leading, spacing: 12) {
                    Text("Access Key：")
                    // .foregroundColor(.secondary)

                    HStack {
                        TextField("", text: $accesskey)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 350)

//                        Button("更改目录") {}.buttonStyle(.borderedProminent)
                    }
                }
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cookie：")
                    // .foregroundColor(.secondary)

                    HStack {
                        TextField("", text: $cookie)
                            .textFieldStyle(.roundedBorder)
                            .frame(maxWidth: 350)

//                        Button("更改目录") {}.buttonStyle(.borderedProminent)
                    }
                }

                Spacer()
            }
            .padding(30)
        }
        .navigationTitle("设置")
//        .background(.regularMaterial)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.title3.bold())
            .foregroundColor(.primary)
    }
}

struct FeatureTag: View {
    let name: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .foregroundColor(.pink)
            Text(name)
        }
        .font(.subheadline)
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct PinkRoundedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 20)
            .background(Color.pink)
            .cornerRadius(10)
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct RadioButton: View {
    let label: String
    @Binding var isSelected: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Circle()
                .strokeBorder(Color.secondary, lineWidth: 1)
                .background(Circle().fill(isSelected ? Color.pink : Color.clear))
                .frame(width: 16, height: 16)
                .onTapGesture { action() }

            Text(label)
                .onTapGesture { action() }
        }
    }
}
