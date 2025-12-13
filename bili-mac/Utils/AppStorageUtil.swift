//
//  AppStorageUtil.swift
//  bili-mac
//
//  Created by zzh on 2025/12/12.
//

import Foundation

class AppStorageUtil {
    init() {}

    func getItem(_ key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }

    func setItem(_ key: String, value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }

    func getString(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    func setString(_ key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
