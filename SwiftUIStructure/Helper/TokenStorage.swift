//
//  TokenStorage.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 10/5/26.
//

import Foundation

final class TokenStorage {
    private var _accessToken: String?
    private var _refreshToken: String?

    var accessToken: String? { _accessToken }
    var refreshToken: String? { _refreshToken }

    func save(accessToken: String, refreshToken: String) {
        self._accessToken = accessToken
        self._refreshToken = refreshToken
    }

    func clear() {
        _accessToken = nil
        _refreshToken = nil
    }
}
