//
//  VideoDetailView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//
import SwiftUI

struct VideoDetailView: View {
    let bvid: String

    var body: some View {
        HStack(spacing: 0) {
            // MARK: - 左侧：视频封面 / 播放区域

            ZStack {
                Rectangle()
                    .fill(Color.black)

                // 封面占位（16:9）
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.25))
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .overlay(
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 64))
                            .foregroundColor(.white.opacity(0.85))
                    )
                    .padding(24)
            }
            .frame(minWidth: 520) // 左侧固定为“播放器区”
            .frame(maxWidth: .infinity)
            .background(Color.black)

            Divider()

            // MARK: - 右侧：视频信息

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 标题
                    Text("这几年，电视画质为什么变差了？")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .fixedSize(horizontal: false, vertical: true)

                    // BV / 时间
                    Text("BV号：\(bvid) · 2025-12-15")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    // 播放数据
                    HStack(spacing: 14) {
                        Label("70.0万", systemImage: "play.fill")
                        Label("2961", systemImage: "text.bubble")
                        Label("6.9万", systemImage: "hand.thumbsup.fill")
                        Label("3.0万", systemImage: "star.fill")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)

                    Divider()

                    // 操作按钮
                    HStack(spacing: 12) {
                        Button("播放") {}
                        Button("收藏") {}
                        Button("投币") {}
                        Button("分享") {}
                    }
                    .buttonStyle(.bordered)

                    Divider()

                    // UP 主
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: 40, height: 40)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("影视飓风")
                                .font(.headline)
                            Text("1456.5万粉丝")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        Button("已关注") {}
                            .buttonStyle(.bordered)
                    }

                    Divider()

                    // 简介
                    VStack(alignment: .leading, spacing: 8) {
                        Text("简介")
                            .font(.headline)

                        Text("""
                        这期视频包含闪光高速效果，可能对部分观众产生不适。

                        你有没有感觉，你看电视的时候画面越来越糊了？
                        这期我们聊聊电视画质为什么变差。
                        """)
                        .font(.body)
                        .foregroundColor(.secondary)
                    }

                    Spacer(minLength: 40)
                }
                .padding(20)
            }
            .frame(width: 360) // 右侧信息栏宽度，接近 B 站
        }
        .navigationTitle("视频详情")
    }
}
