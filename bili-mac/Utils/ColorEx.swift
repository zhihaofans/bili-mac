//
//  ColorEx.swift
//  bili-mac
//
//  Created by zzh on 2026/1/2.
//

import Foundation
import SwiftUI

extension Color {
    static let biliPink = Color(
        red: 251 / 255,
        green: 114 / 255,
        blue: 153 / 255
    )
    /// 支持：
    /// - RGB  (如 #F0A)
    /// - RRGGBB (如 #FB7299)
    /// - AARRGGBB (如 #FFFB7299)
    init(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hex = hex.replacingOccurrences(of: "#", with: "")

        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)

        let r, g, b, a: Double

        switch hex.count {
        case 3: // RGB (12-bit)
            r = Double((value >> 8) & 0xF) / 15.0
            g = Double((value >> 4) & 0xF) / 15.0
            b = Double(value & 0xF) / 15.0
            a = 1.0

        case 6: // RRGGBB (24-bit)
            r = Double((value >> 16) & 0xFF) / 255.0
            g = Double((value >> 8) & 0xFF) / 255.0
            b = Double(value & 0xFF) / 255.0
            a = 1.0

        case 8: // AARRGGBB (32-bit)
            a = Double((value >> 24) & 0xFF) / 255.0
            r = Double((value >> 16) & 0xFF) / 255.0
            g = Double((value >> 8) & 0xFF) / 255.0
            b = Double(value & 0xFF) / 255.0

        default:
            r = 0; g = 0; b = 0; a = 1
        }

        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
