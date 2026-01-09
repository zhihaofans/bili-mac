//
//  ImageView.swift
//  bili-mac
//
//  Created by zzh on 2026/1/9.
//

import SwiftUI
import SwiftUtils

struct ImageMenu: View {
    let img: String
    var body: some View {
        Button("复制图片链接") {
            ClipboardUtil().setString(img.httpToHttps)
        }
        Button("预览图片") {
            PreviewUtil.showPreview(url: img.httpToHttps)
        }
    }
}
