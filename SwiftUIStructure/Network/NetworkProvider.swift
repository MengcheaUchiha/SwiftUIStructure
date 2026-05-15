//
//  NetworkProvider.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 10/5/26.
//

import Foundation
import Moya

final class NetworkProvider<T: TargetType> {

    private let provider: MoyaProvider<T>
    
    init(provider: MoyaProvider<T>) {
        self.provider = provider
    }

    func request(_ target: T) async throws -> Response {
        do {
            let response = try await provider.request(target)

            if response.statusCode == 401 {
//                return try await retryAfterRefresh(target)
            }

            return response

        } catch {
            throw error
        }
    }
    
}
