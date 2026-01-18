//
//  VideoService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/16.
//
import Alamofire
import Foundation
import SwiftUtils

class VideoService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": AccountService().cookie,
        "User-Agent": DefaultData.UA_MAC_WEB,
        "Content-Type": DefaultData.ContentType_FORM,
        "Referer": "https://www.bilibili.com/",
    ]
    init() {
        http.setHeader(headers)
    }

    func getVideoDetail(bvid: String, callback: @escaping (BiliVideoInfoData)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/view?bvid=" + bvid
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    let data = try JSONDecoder().decode(BiliVideoInfoResult.self, from: result.data(using: .utf8)!)
                    SU.log.i("getHomePage")
                    SU.log.info(data.code)
                    if data.code == 0, data.data != nil {
                        callback(data.data!)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    SU.log.e(error.localizedDescription)
                    SU.log.e("getVideoDetail.catch.error")
                    fail("getVideoDetail:\(error)")
                }
            }
        } fail: { error in
            SU.log.e(error)
            SU.log.e("getVideoDetail.http.error")
            fail("getVideoDetail:\(error)")
        }
    }
}
