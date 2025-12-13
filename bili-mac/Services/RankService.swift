//
//  RankService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/12.
//
import Alamofire
import Foundation
import SwiftUtils

class RankService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        // "Cookie": BiliLoginService().getCookiesString(),
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.bilibili.com/",
    ]
    init() {
        http.setHeader(headers)
    }

    func getHomePage(callback: @escaping (BiliRankResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/popular?ps=50"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    print("getRankList")
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getLaterToWatch.catch.error")
                    fail("getLaterToWatch:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getLaterToWatch.http.error")
            fail("getLaterToWatch:\(error)")
        }
    }
}
