//
//  Data.swift
//  bili-mac
//
//  Created by zzh on 2025/12/24.
//
import Alamofire
import Foundation

class DefaultData {
    static let UA_MAC_WEB = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Safari/605.1.15"
    static let ContentType_FORM = "application/x-www-form-urlencoded"
    static let Referer_BILI = "https://www.bilibili.com/"
    static let HEADERS: HTTPHeaders = [
        "Cookie": AccountService().cookie,
        "User-Agent": DefaultData.UA_MAC_WEB,
        "Content-Type": DefaultData.ContentType_FORM,
        "Referer": DefaultData.Referer_BILI,
    ]

    init() {}
}
