//
//  UserContainer.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 12/6/26.
//

import Foundation

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
