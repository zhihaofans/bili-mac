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
