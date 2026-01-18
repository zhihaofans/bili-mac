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
    private let headers: HTTPHeaders = DefaultData.HEADERS
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
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    SU.log.i("getTopRanking")
                    SU.log.info(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    SU.log.e(error.localizedDescription)
                    SU.log.e("getTopRanking.catch.error")
                    fail("getTopRanking:\(error)")
                }
            }
        } fail: { error in
            SU.log.e(error)
            SU.log.e("getTopRanking.http.error")
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
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    SU.log.i("getHomePage")
                    SU.log.info(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    SU.log.e(error.localizedDescription)
                    SU.log.e("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            SU.log.e(error)
            SU.log.e("getHomePage.http.error")
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
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    SU.log.i("getHomePage")
                    SU.log.info(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    SU.log.e(error.localizedDescription)
                    SU.log.e("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            SU.log.e(error)
            SU.log.e("getHomePage.http.error")
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
                    let data = try JSONDecoder().decode(BiliRankResult.self, from: result.data(using: .utf8)!)
                    SU.log.i("getHomePage")
                    SU.log.info(data.code)
                    if data.code == 0 {
                        callback(data)
                    } else {
                        fail("Code \(data.code): \(data.message)")
                    }
                } catch {
                    SU.log.e(error.localizedDescription)
                    SU.log.e("getHomePage.catch.error")
                    fail("getHomePage:\(error)")
                }
            }
        } fail: { error in
            SU.log.e(error)
            SU.log.e("getHomePage.http.error")
            fail("getHomePage:\(error)")
        }
    }
}
