//
//  HistoryService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/18.
//
import Alamofire
import Foundation
import SwiftUtils

class LaterToWatchService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = [
        "Cookie": AccountService().cookie,
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Safari/605.1.15",
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.bilibili.com/",
    ]
    init() {
        http.setHeader(headers)
    }

    func getList(callback: @escaping (LaterWatchListData)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/v2/history/toview"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(LaterWatchListResultModel.self, from: result.data(using: .utf8)!)
                    print("LaterWatchgetList")
                    debugPrint(data.code)
                    if data.code == 0, data.data != nil {
                        callback(data.data!)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("LaterWatchgetList.catch.error")
                    fail("LaterWatchgetList:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("LaterWatchgetList.http.error")
            fail("LaterWatchgetList:\(error)")
        }
    }
}
