//
//  DIContainer.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 10/5/26.
//

import SwiftUI
import Moya

// MARK: - Root Container

final class DIContainer {

    lazy var tokenStorage: TokenStorage = {
        TokenStorage()
    }()

    static let shared = DIContainer()

    private init() {}

    // MARK: - Containers

    lazy var networkContainer: NetworkContainer = {
        NetworkContainer(tokenStorage: tokenStorage)
    }()

    lazy var userContainer: UserContainer = {
        UserContainer(network: networkContainer)
    }()

}
