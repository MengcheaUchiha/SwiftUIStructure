//
//  TestAPI.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import Foundation
import Moya
internal import Alamofire

enum UserAPI: TargetType {
    case users
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var path: String {
        switch self {
        case .users: return "/users"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}
