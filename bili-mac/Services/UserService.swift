//
//  UserService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/24.
//
import Alamofire
import Foundation
import SwiftUtils

class UserService {
    private let http = HttpUtil()
    private let headers: HTTPHeaders = DefaultData.HEADERS
    init() {
        http.setHeader(headers)
    }

    func getUserSpaceInfo(callback: @escaping (UserSpaceInfoData)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/space/myinfo"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(UserSpaceInfoResult.self, from: result.data(using: .utf8)!)
                    print("getUserSpaceInfo")
                    debugPrint(data.code)
                    if data.code == 0, data.data != nil {
                        callback(data.data!)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getUserSpaceInfo.catch.error")
                    fail("getUserSpaceInfo:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getUserSpaceInfo.http.error")
            fail("getUserSpaceInfo.fail:\(error)")
        }
    }
}
