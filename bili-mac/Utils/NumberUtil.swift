//
//  NumberUtil.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//

import Foundation

class NumberUtil {
    public init() {}
    public func formatDuration(_ seconds: Int) -> String {
        // 秒数转成文本时间（最大到小时）
        guard seconds > 0 else { return "0秒" }

        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60

        if hour > 0 {
            return String(format: "%d:%02d:%02d", hour, minute, second)
        } else {
            return String(format: "%d:%02d", minute, second)
        }
    }

    public func formatPlayCount(_ count: Int) -> String {
        // 视频弹幕、播放数字格式化
        if count < 10_000 {
            return "\(count)"
        } else {
            let value = Double(count) / 10_000
            return String(format: "%.1f万", value)
                .replacingOccurrences(of: ".0", with: "")
        }
    }
}
