//
//  VideoModel.swift
//  bili-mac
//
//  Created by zzh on 2025/12/12.
//

import Foundation

struct BiliVideoInfoResult: Codable {
    let code: Int
    let message: String
    let data: BiliVideoInfoData?
}

struct BiliVideoInfoData: Codable {
    let bvid: String
    let aid: Int
    let videos: Int // 稿件分P总数
    let pic: String
    let cover43: String?
    let title: String
    let pubdate: Int // 稿件发布时间
    let ctime: Int // 用户投稿时间
    let desc: String
    let duration: Int // 稿件总时长(所有分P)
    let owner: VideoOwner
    let tname: String? // 分区类型
    let dynamic: String // 视频同步发布的的动态的文b字内容
    let no_cache: Bool? // 是否不允许缓存?
    let pages: [BiliVideoInfoPagesItem]? // 视频分P列表
    let short_link_v2: String? // 短链接
    let stat: VideoStat // 视频状态数
}

struct VideoOwner: Codable {
    let mid: Int
    let name: String
    let face: String
}

struct BiliVideoInfoPagesItem: Codable {
    let cid: Int
    let page: Int // 分P序号，从1开始
    let from: String // 视频来源，    vupload：普通上传（B站）、hunan：芒果TV、qq：腾讯
    let part: String // 分P标题
    let duration: Int // 分P持续时间
}

struct VideoStat: Codable {
    let aid: Int
    let view: Int
    let danmaku: Int
    let reply: Int
    let favorite: Int
    let coin: Int
    let share: Int
    let nowRank: Int
    let hisRank: Int
    let like: Int
    let evaluation: String?

    enum CodingKeys: String, CodingKey {
        case aid
        case view
        case danmaku
        case reply
        case favorite
        case coin
        case share
        case nowRank = "now_rank"
        case hisRank = "his_rank"
        case like
        case evaluation
    }
}
