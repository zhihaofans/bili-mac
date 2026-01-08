//
//  PreviewUtil.swift
//  bili-mac
//
//  Created by zzh on 2026/1/9.
//

import AppKit
import QuickLook
import QuickLookUI

/// Quick Look 预览工具
enum PreviewUtil {
    /// 打开系统预览（Finder 空格键同款）
    static func showPreview(url: URL) {
        guard let panel = QLPreviewPanel.shared() else { return }

        let dataSource = PreviewDataSource(items: [url])
        panel.dataSource = dataSource

        // 关键：必须强引用，否则会被释放
        PreviewDataSourceHolder.shared.dataSource = dataSource

        panel.makeKeyAndOrderFront(nil)
    }

    static func showPreview(url: String) {
        if let fileURL = URL(string: url) {
            showPreview(url: fileURL)
        }
    }
}

/// 数据源（直接使用 NSURL，避免 QLPreviewItem 不可见问题）
final class PreviewDataSource: NSObject, QLPreviewPanelDataSource {
    let items: [URL]

    init(items: [URL]) {
        self.items = items
    }

    func numberOfPreviewItems(in panel: QLPreviewPanel!) -> Int {
        items.count
    }

    func previewPanel(_ panel: QLPreviewPanel!,
                      previewItemAt index: Int) -> QLPreviewItem!
    {
        return items[index] as NSURL
    }
}

/// 用于持有 dataSource，避免 Quick Look 面板瞬间白屏
private final class PreviewDataSourceHolder {
    static let shared = PreviewDataSourceHolder()
    var dataSource: PreviewDataSource?
}
