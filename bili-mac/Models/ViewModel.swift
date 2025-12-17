//
//  VideoItem.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import Foundation

struct VideoItem: Identifiable {
    let id = UUID()

    let cover: String // 图片名 或 URL
    let title: String // 标题
    let play: String // 播放量
    let danmaku: String // 弹幕数
    let duration: String // 视频时长
    let author_name: String // UP 主
    let author_face: String // UP 主头像
    let date: String // 发布时间
    let url: String
    let bvid: String
}
