//
//  DynamicModel.swift
//  bili-mac
//
//  Created by zzh on 2025/12/28.
//

import Foundation

enum DynamicType: String {
    case none = "DYNAMIC_TYPE_NONE"
    case forward = "DYNAMIC_TYPE_FORWARD"
    case av = "DYNAMIC_TYPE_AV"
    case pgc = "DYNAMIC_TYPE_PGC"
    case courses = "DYNAMIC_TYPE_COURSES"
    case word = "DYNAMIC_TYPE_WORD"
    case draw = "DYNAMIC_TYPE_DRAW"
    case article = "DYNAMIC_TYPE_ARTICLE"
    case music = "DYNAMIC_TYPE_MUSIC"
    case commonSquare = "DYNAMIC_TYPE_COMMON_SQUARE"
    case live = "DYNAMIC_TYPE_LIVE"
    case mediaList = "DYNAMIC_TYPE_MEDIALIST"
    case coursesSeason = "DYNAMIC_TYPE_COURSES_SEASON"
    case liveRcmd = "DYNAMIC_TYPE_LIVE_RCMD"
    case ugcSeason = "DYNAMIC_TYPE_UGC_SEASON"

    var text: String {
        switch self {
        case .none: return "无效动态"
        case .forward: return "动态转发"
        case .av: return "投稿视频"
        case .pgc: return "剧集（番剧、电影、纪录片）"
        case .courses: return "课程"
        case .word: return "纯文字动态"
        case .draw: return "带图动态"
        case .article: return "投稿专栏"
        case .music: return "音乐"
        case .commonSquare: return "装扮、剧集点评、普通分享"
        case .live: return "直播间分享"
        case .mediaList: return "收藏夹"
        case .coursesSeason: return "课程"
        case .liveRcmd: return "直播开播"
        case .ugcSeason: return "合集更新"
        }
    }
}

// 动态主体类型
enum MajorType: String {
    case archive = "MAJOR_TYPE_ARCHIVE"
    case opus = "MAJOR_TYPE_OPUS"

    var text: String {
        switch self {
        case .archive: return "视频"
        case .opus: return "图文动态"
        }
    }
}

// 参考：https://github.com/SocialSisterYi/bilibili-API-collect/blob/master/docs/dynamic/all.md
struct DynamicListResultModel: Codable {
    let code: Int
    let message: String
    let data: DynamicListData?
}

struct DynamicListData: Codable {
    let hasMore: Bool
    let items: [DynamicListItem]?
    let offset: String
    let updateBaseline: String
    let updateNum: Int

    enum CodingKeys: String, CodingKey {
        case hasMore = "has_more"
        case items
        case offset
        case updateBaseline = "update_baseline"
        case updateNum = "update_num"
    }
}

struct DynamicListItem: Codable {
    let basic: DynamicListItemBasic
    let id: String
    let modules: DynamicListItemModule
    let type: String
    let visible: Bool
    // let orig: DynamicListItem?

    enum CodingKeys: String, CodingKey {
        case basic
        case id = "id_str"
        case modules
        case type
        case visible
        // case orig
    }

    /// ✅ 扩展字段，不参与 Codable
    var authorface: String {
        modules.author.face
    }

    var authorId: Int {
        modules.author.mid
    }

    var authorName: String {
        modules.author.name
    }

    var cover: String? {
        switch type {
        case DynamicType.av.rawValue:
            modules.dynamic.major?.archive?.cover
        case DynamicType.draw.rawValue:
            modules.dynamic.major?.opus?.pics.first?.url
        default:
            nil
        }
    }

    var desc: String? {
        modules.dynamic.desc?.text ?? modules.dynamic.major?.archive?.desc ?? opus?.summary.text
    }

    var isSupported: Bool {
        switch type {
        case DynamicType.av.rawValue:
            true
        case DynamicType.draw.rawValue:
            true
        case DynamicType.word.rawValue:
            true
        default:
            false
        }
    }

    var majorType: MajorType? {
        modules.dynamic.major?.type
            .flatMap { MajorType(rawValue: $0) }
    }

    var onlyFans: Bool {
        basic.is_only_fans ?? false
    }

    var opus: ModuleDynamicMajorOpus? {
        modules.dynamic.major?.opus
    }

    var pushTime: String {
        modules.author.pub_time
    }

    var title: String? {
        switch type {
        case DynamicType.av.rawValue:
            modules.dynamic.major?.archive?.title
        case DynamicType.draw.rawValue:
            modules.dynamic.major?.opus?.title
        case DynamicType.word.rawValue:
            modules.dynamic.major?.archive?.title
        default:
            nil
        }
    }

    var typeName: String {
        DynamicType(rawValue: type)?.text ?? type
    }

    var url: String? {
        switch type {
        case DynamicType.av.rawValue:
            modules.dynamic.major?.archive?.jump_url
        default:
            nil
        }
    }
}

struct DynamicListItemBasic: Codable {
    let is_only_fans: Bool?
}

struct DynamicListItemModule: Codable {
    let author: ModuleTypeAuthor
    let dynamic: ModuleDynamic
    enum CodingKeys: String, CodingKey {
        case author = "module_author"
        case dynamic = "module_dynamic"
    }
}

struct DynamicListItemMajor: Codable {
    let is_only_fans: Bool?
}

struct ModuleTypeAuthor: Codable {
    let face: String
    let mid: Int
    let name: String
    let jump_url: String
    let pub_action: String
    let pub_time: String // 更新时间,x分钟前
    let pub_ts: Int // 更新时间戳
}

struct ModuleDynamic: Codable {
    let desc: ModuleDynamicDesc?
    let major: ModuleDynamicMajor?
}

struct ModuleDynamicDesc: Codable {
    let text: String?
}

struct ModuleDynamicMajor: Codable {
    let type: String?
    let archive: ModuleDynamicMajorArchive? // 投稿视频
    let opus: ModuleDynamicMajorOpus? // 图文动态opus
}

struct ModuleDynamicMajorArchive: Codable {
    let title: String
    let desc: String
    let cover: String
    let jump_url: String?
    let bvid: String?
    let stat: ModuleTyperchiveStat
    let duration_text: String // 视频长度
}

struct ModuleDynamicMajorOpus: Codable {
    let jump_url: String?
    let pics: [ModuleDynamicMajorOpusPics]
    let summary: ModuleDynamicMajorOpusSummary // 动态内容
    let title: String?
}

struct ModuleDynamicMajorOpusPics: Codable {
    let size: Float
    let height: Float
    let url: String
    let width: Float
}

struct ModuleDynamicMajorOpusSummary: Codable {
    let text: String
}

struct ModuleTyperchiveStat: Codable {
    let danmaku: String
    let play: String
}
