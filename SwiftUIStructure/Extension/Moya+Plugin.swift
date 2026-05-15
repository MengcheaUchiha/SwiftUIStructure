//
//  Moya+Plugin.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 10/5/26.
//

import Moya
import Foundation

final class AuthPlugin: PluginType {
    private let tokenStorage: TokenStorage

    init(tokenStorage: TokenStorage) {
        self.tokenStorage = tokenStorage
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let token = tokenStorage.accessToken else {
            return request
        }

        var request = request
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}

final class CustomLoggerPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        print("➡️ \(request.request?.httpMethod ?? "") \(request.request?.url?.absoluteString ?? "")")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            print("✅ \(response.statusCode) \(target.path)")
        case .failure(let error):
            print("❌ \(error.localizedDescription)")
        }
    }
}
