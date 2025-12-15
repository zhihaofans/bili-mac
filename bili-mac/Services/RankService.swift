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
        "Cookie": AccountService().cookie,
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.1 Safari/605.1.15",
        "Content-Type": "application/x-www-form-urlencoded",
        "Referer": "https://www.bilibili.com/",
    ]
    init() {
        http.setHeader(headers)
    }

    // 排行榜
    func getTopRanking(callback: @escaping (BiliRankResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/ranking/v2"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    print("getTopRanking")
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getTopRanking.catch.error")
                    fail("getTopRanking:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getTopRanking.http.error")
            fail("getTopRanking:\(error)")
        }
    }

    // 当前热门视频列表
    func getNowHot(callback: @escaping (BiliRankResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/popular?ps=50"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    print("getHomePage")
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getHomePage.http.error")
            fail("getHomePage:\(error)")
        }
    }

    // 入站必刷视频
    func getNoobPrecious(callback: @escaping (BiliRankResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/popular/precious"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    print("getHomePage")
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getHomePage.http.error")
            fail("getHomePage:\(error)")
        }
    }
    // 入站必刷视频
    func getWeekVideo(callback: @escaping (BiliRankResult)->Void, fail: @escaping (String)->Void) {
        let url = "https://api.bilibili.com/x/web-interface/popular/series/one?number=1"
        http.get(url) { result in
            if result.isEmpty {
                fail("result.isEmpty")
            } else {
                do {
                    print(result)
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    print("getHomePage")
                    debugPrint(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    print(error)
                    print("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            print(error)
            print("getHomePage.http.error")
            fail("getHomePage:\(error)")
        }
    }
}
