//
//  TokenStorage.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 10/5/26.
//

import Foundation

final class TokenStorage {
    private let queue = DispatchQueue(label: "TokenStorageQueue")

    private var _accessToken: String?
    private var _refreshToken: String?

    var accessToken: String? {
        queue.sync { _accessToken }
    }

    var refreshToken: String? {
        queue.sync { _refreshToken }
    }

    func save(accessToken: String, refreshToken: String) {
        queue.sync {
            self._accessToken = accessToken
            self._refreshToken = refreshToken
        }
    }

    func clear() {
        queue.sync {
            _accessToken = nil
            _refreshToken = nil
        }
    }
}
