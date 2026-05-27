//
//  Moya+Extension.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import Foundation
@preconcurrency import Moya

extension MoyaProvider {
    
    func request(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
