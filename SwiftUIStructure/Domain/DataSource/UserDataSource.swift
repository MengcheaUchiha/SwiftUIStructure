//
//  UserDataSource.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 30/4/26.
//

import Moya
import Foundation

protocol UserRemoteDataSource {
    func fetchUsers() async throws -> [UserModel]
}

final class UserRemoteDataSourceImpl: UserRemoteDataSource {
    private let provider: NetworkProvider<UserAPI>

    init(provider: NetworkProvider<UserAPI>) {
        self.provider = provider
    }

    func fetchUsers() async throws -> [UserModel] {
        let response = try await provider.request(.users)
        return try JSONDecoder().decode([UserModel].self, from: response.data)
    }
}
