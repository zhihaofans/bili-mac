//
//  NumberUtil.swift
//  bili-mac
//
//  Created by zzh on 2025/12/15.
//

import Foundation

class NumberUtil {
    init() {}
    func formatDuration(_ seconds: Int) -> String {
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

    func formatPlayCount(_ count: Int) -> String {
        // 视频弹幕、播放数字格式化
        if count < 10000 {
            return "\(count)"
        } else {
            let value = Double(count) / 10000
            return String(format: "%.1f万", value)
                .replacingOccurrences(of: ".0", with: "")
        }
    }

    func formatPastTime(_ timestampInt: Int) -> String {
        return formatPastTime(TimeInterval(timestampInt))
    }

    func formatPastTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let now = Date()

        let calendar = Calendar.current
        let diff = now.timeIntervalSince(date)

        // 1️⃣ 一小时内
        if diff < 3600 {
            return "刚刚"
        }

        // 2️⃣ 1 - 24 小时
        if diff < 86400 {
            let hours = Int(diff / 3600)
            return "\(hours)小时前"
        }

        let dateYear = calendar.component(.year, from: date)
        let nowYear = calendar.component(.year, from: now)

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")

        // 3️⃣ 今年
        if dateYear == nowYear {
            formatter.dateFormat = "MM-dd"
            return formatter.string(from: date)
        }

        // 4️⃣ 去年及以前
        formatter.dateFormat = "yy-MM-dd"
        return formatter.string(from: date)
    }
}
