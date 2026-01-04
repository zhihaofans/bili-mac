//
//  DynamicService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/29.
//
import Alamofire
import Foundation
import SwiftUtils

class DynamicService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = DefaultData.HEADERS
   

    init() {
        http.setHeader(headers)
    }

    func getDynamicList(offset: String = "", callback: @escaping (DynamicListData)->Void, fail: @escaping (String)->Void) {
        let features = "itemOpusStyle%2ClistOnlyfans%2ConlyfansVote%2ConlyfansAssetsV2"
        let url = "https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all?platform=web&features=" + features + "&offset=" + offset
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(DynamicListResultModel.self, from: result.data(using: .utf8)!)
                    print("getDynamicList")
                    debugPrint(data.code)
                    if data.code == 0, data.data != nil {
                        callback(data.data!)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print("=====getDynamicList.catch.error======")
                    print(error)
                    print("getDynamicList.catch.error")
                    fail("getDynamicList:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getDynamicList.http.error")
            fail("getDynamicList.fail:\(error)")
        }
    }
}
