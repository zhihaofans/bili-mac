//
//  AccountService.swift
//  bili-mac
//
//  Created by zzh on 2025/12/11.
//

import Foundation
import SwiftUtils

class AccountService {
    var accesskey: String {
        get { UserDefaultUtil().getString(SettingsKeys.auth_accesskey) ?? "" }
        set { UserDefaultUtil().setString(key: SettingsKeys.auth_accesskey, value: newValue) }
    }

    var cookie: String {
        get { UserDefaultUtil().getString(forKey: SettingsKeys.auth_cookie) ?? "" }
        set { UserDefaultUtil().setString(key: SettingsKeys.auth_cookie, value: newValue) }
    }

    func isLogin(callback: @escaping (Bool) -> Void) {
        callback(!accesskey.isEmpty && !cookie.isEmpty)
    }
}
