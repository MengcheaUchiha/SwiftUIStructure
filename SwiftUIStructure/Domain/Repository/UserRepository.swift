//
//  UserRepository.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 30/4/26.
//

import Moya
import Foundation

protocol UserRepository {
    func fetchUsers() async throws -> [UserModel]
}

class UserRepositoryImpl: UserRepository {
    
    let remote: UserRemoteDataSource
    
    init(remote: UserRemoteDataSource) {
        self.remote = remote
    }
    
    func fetchUsers() async throws -> [UserModel] {
        return try await remote.fetchUsers()
    }
    
}
