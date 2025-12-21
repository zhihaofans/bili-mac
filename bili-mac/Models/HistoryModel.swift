//
//  HistoryModel.swift
//  bili-mac
//
//  Created by zzh on 2025/12/18.
//

import Foundation

struct LaterWatchListResultModel: Codable {
    let code: Int
    let message: String
    let data: LaterWatchListData?
}

struct LaterWatchListData: Codable {
    let count: Int
    let list: [LaterWatchListItem]?
}

struct LaterWatchListItem: Codable {
    let aid: Int
    let bvid: String
    let cid: Int
    let videos: Int // 稿件分P总数
    let pic: String // 封面
    let cover43: String // 4:3封面
    let first_frame: String? // 视频第一帧图
    let view_text_1: String // 观看到第几秒，格式化后的字符串
    let pub_location: String? // 稿件发布定位
    let tid: Int // 分区ID
    let tname: String // 分区名称
    let title: String
    let copyright: Int // 版权类型，1：原创，2：转载
    let pubdate: Int // 稿件发布时间戳
    let ctime: Int // 用户投稿时间戳
    let desc: String
    let duration: Int // 稿件总时长(所有分P)
    let owner: VideoOwner
    let stat: VideoStat
    let progress: Int // 观看进度时间,单位为秒
    let add_at: Int // 添加到稍后再看的时间戳
    let uri: String // 视频链接
}

struct LaterWatchListItemPage: Codable {
    let from: String // 视频来源，    vupload：普通上传（B站）、hunan：芒果TV、qq：腾讯
    let dimension: String // 视频分辨率
    let first_frame: LaterWatchListItemPageDimension // 视频分P第一帧图
    let part: String // 分P标题
    let ctime: Int // 分P创建时间戳
    let duration: Int // 分P持续时间
    let page: Int // 分P序号，从1开始
    let cid: Int // 分P cid
}

struct LaterWatchListItemPageDimension: Codable {
    let width: Int // 宽
    let rotate: Int // 旋转
    let height: Int // 高
}

struct HistoryListResultModel: Codable {
    let code: Int
    let message: String
    let data: HistoryListData?
}

struct HistoryListData: Codable {
    let list: [HistoryListItem]?
}

struct HistoryListItem: Codable {
    let title: String
    let long_title: String // 副标题
    let cover: String
    let covers: [String]?
    let uri: String? // 重定向 url,仅用于剧集和直播
    let history: HistoryListItemDetail
    let videos: Int? // 稿件分P总数,仅用于稿件视频
    let author_name: String // 作者名称
    let author_face: String // 作者头像
    let author_mid: Int // 作者 mid
    let view_at: Int // 观看时间戳
    let progress: Int? // 观看进度时间,单位为秒,用于稿件视频或剧集
    let badge: String? // 历史记录标签，如稿件视频 / 剧集 / 笔记 / 直播等
    let show_title: String? // 分 P 标题,用于稿件视频或剧集
    let duration: Int? // 视频总时长,单位为秒,用于稿件视频或剧集
    let total: Int? // 总集数,仅用于剧集
    let new_desc: String? // 最新一话 / 最新一 P 标识,用于稿件视频或剧集
    let is_finish: Int? // 是否完结,仅用于剧集, 0：未完结/1：已完结
    let is_fav: Int // 是否已收藏, 0：未收藏/1：已收藏
    let tag_name: String? // 子分区名,用于稿件视频和直播
    let live_status: Int? // 直播状态,仅用于直播, 0：未开播/1：直播中
}

struct HistoryListItemDetail: Codable {
    let business: String // 业务类型，如 archive：稿件，pgc：剧集（番剧 / 影视），live：直播，article-list：文集，article：文章
    let dt: Int // 观看设备平台，1 3 5 7：手机端，2：web端，4 6：pad端，9: 智能音箱/游戏机，33：TV端，0：其他
    let bvid: String?
    let oid: Int // 稿件视频&剧集：稿件avid，直播：直播间id，文章：文章cvid，文集：文集rlid
    let cid: Int? // 分 P cid
    let page: Int? // 分 P 序号，从 1 开始
    let part: String? // 仅用于稿件视频，分 P 标题
}
