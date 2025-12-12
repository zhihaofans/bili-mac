//
//  VideoItemView.swift
//  bili-mac
//
//  Created by zzh on 2025/12/12.
//

import SwiftUI

struct VideoCard: View {
    let video: VideoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: video.cover)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(height: 140)
                .clipped()
                .cornerRadius(10)

                HStack {
                    Label(video.play, systemImage: "play.fill")
                    Label(video.danmaku, systemImage: "text.bubble")
                }
                .font(.caption2)
                .padding(4)
                .background(.thinMaterial)
                .cornerRadius(4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(6)
                Text(video.duration)
                    .font(.caption2)
                    .padding(4)
                    .background(.thinMaterial)
                    .cornerRadius(4)
                    .padding(6)
            }
            HStack {
                AsyncImage(url: URL(string: video.author_face)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.2)
                }
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                Text(video.author_name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            Text(video.title)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
        .padding(8)
        .background(.regularMaterial) // 自动亮/暗
        .cornerRadius(12)
    }
}
