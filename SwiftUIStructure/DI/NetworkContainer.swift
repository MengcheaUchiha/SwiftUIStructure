//
//  NetworkContainer.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 12/6/26.
//

import Foundation
import Moya

// MARK: - Network Container

final class NetworkContainer {

    private let tokenStorage: TokenStorage

    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }

    // MARK: Plugins

    lazy var plugins: [PluginType] = {
        [
            AuthPlugin(tokenStorage: tokenStorage),
            CustomLoggerPlugin()
        ]
    }()

    // MARK: Providers

    lazy var userProvider: MoyaProvider<UserAPI> = {
        MoyaProvider<UserAPI>(
            plugins: plugins
        )
    }()

    // MARK: Network Wrappers

    lazy var userNetworkProvider: NetworkProvider<UserAPI> = {
        NetworkProvider<UserAPI>(
            provider: userProvider,
        )
    }()
    
}
