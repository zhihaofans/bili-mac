//
//  MockData.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import Foundation

enum MockData {
    static let cover = "https://picsum.photos/400/300?random=1"
    static let videos: [VideoItem] = [
        VideoItem(
            cover: cover,
            title: "我和她的微妙关系",
            play: "90.6万",
            danmaku: "53",
            duration: "01:15",
            author_name: "Biu_某某",
            author_face: cover,
            date: "12-8"
        ),
        VideoItem(
            cover: cover,
            title: "被骗300年！《红楼梦》根本不是爱情小说",
            play: "53.4万",
            danmaku: "1676",
            duration: "07:37",
            author_name: "文史拾遗",
            author_face: cover,
            date: "12-9"
        ),
        VideoItem(
            cover: cover,
            title: "没有比这更逆天的视频了",
            play: "17.8万",
            danmaku: "109",
            duration: "01:39",
            author_name: "某某实验室",
            author_face: cover,
            date: "12-7"
        ),
        VideoItem(
            cover: cover,
            title: "GTR 修车第 389 天，日产终于来了一台新车？",
            play: "209.3万",
            danmaku: "2047",
            duration: "09:15",
            author_name: "极速拍档-NANA",
            author_face: cover,
            date: "12-4"
        ),
        VideoItem(
            cover: cover,
            title: "为什么人类会对“高颜值”上头？谁定义了我们的审美？",
            play: "65.7万",
            danmaku: "1804",
            duration: "11:12",
            author_name: "太阳星sunstar",
            author_face: cover,
            date: "12-5"
        ),
        VideoItem(
            cover: cover,
            title: "把老公装修成西装暴徒！夫妻生活更上一层楼！",
            play: "20.1万",
            danmaku: "910",
            duration: "04:46",
            author_name: "一只财茶茶呀",
            author_face: cover,
            date: "昨天"
        ),
        VideoItem(
            cover: cover,
            title: "这是今年最好笑的电影？笑爆盘点 2025 年度十大烂片！",
            play: "359.6万",
            danmaku: "3157",
            duration: "16:52",
            author_name: "三代鹿人",
            author_face: cover,
            date: "12-6"
        ),
        VideoItem(
            cover: cover,
            title: "这才是疯狂动物城 2 主题曲《Zoo》原版 MV",
            play: "23.5万",
            danmaku: "109",
            duration: "03:07",
            author_name: "迪士尼果然给",
            author_face: cover,
            date: "12-5"
        )
    ]
}
