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

// MARK: - User Container

final class UserContainer {

    private let network: NetworkContainer

    init(network: NetworkContainer) {
        self.network = network
    }

    // MARK: Data Sources

    lazy var userRemoteDataSource: UserRemoteDataSource = {
        UserRemoteDataSourceImpl(
            provider: network.userNetworkProvider
        )
    }()

    // MARK: Repositories

    lazy var userRepository: UserRepository = {
        UserRepositoryImpl(
            remote: userRemoteDataSource
        )
    }()

    // MARK: UseCases

    lazy var fetchUsersUseCase: UsersUseCase = {
        UsersUseCaseImpl(
            repository: userRepository
        )
    }()

    // MARK: ViewModels

    @MainActor
    func makeUsersViewModel() -> UserViewModel {
        UserViewModel(
            userUseCase: fetchUsersUseCase
        )
    }
    
}
