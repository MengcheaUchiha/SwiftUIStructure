//
//  UsersUseCase.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 30/4/26.
//

import Moya
import Foundation

protocol UsersUseCase {
    func fetchUsers() async throws -> [UserModel]
}

final class UsersUseCaseImpl: UsersUseCase {
    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func fetchUsers() async throws -> [UserModel] {
        try await repository.fetchUsers()
    }

}
