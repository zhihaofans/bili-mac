//
//  AccountService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import Foundation

class AccountService {
    var accesskey: String {
        get { UserDefaults.standard.string(forKey: SettingsKeys.auth_accesskey) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: SettingsKeys.auth_accesskey) }
    }

    var cookie: String {
        get { UserDefaults.standard.string(forKey: SettingsKeys.auth_cookie) ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: SettingsKeys.auth_cookie) }
    }

    func isLogin(callback: @escaping (Bool) -> Void) {
        callback(!accesskey.isEmpty && !cookie.isEmpty)
    }
}
