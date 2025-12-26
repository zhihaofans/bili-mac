//
//  UserModel.swift
//  bili-mac
//
//  Created by zzh on 2025/12/24.
//

import Foundation

struct UserSpaceInfoResult: Codable {
    let code: Int
    let message: String
    let data: UserSpaceInfoData?
}

struct UserSpaceInfoData: Codable {
    let mid: Int
    let name: String
    let sex: String
    let face: String
    let sign: String
    let level: Int
    let coins: Double
    let following: Int
    let follower: Int
    let vip: UserVipData
}

struct UserVipData: Codable {
    let type: Int
    let status: Int
    let due_date: Int
    let label: UserVipDataLabel
    let avatar_subscript: Int // 是否显示会员图标,0：不显示,1：显示
    let nickname_color: String // 会员昵称颜色 颜色码
}

struct UserVipDataLabel: Codable {
    let label_theme: String
    let text: String
}
