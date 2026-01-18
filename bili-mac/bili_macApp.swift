//
//  bili_macApp.swift
//  bili-mac
//
//  Created by zzh on 2025/12/10.
//

import SwiftUI
import SwiftUtils

@main
struct bili_macApp: App {
    // 这个加了之后，关闭最后一个窗口时，应用会退出
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    init() {
        SU.configureLogger(label: "github.zhihaofans.bili-mac")
    }
}

import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(
        _ sender: NSApplication
    ) -> Bool {
        true
    }
}
