//
//  AlbumAPI.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

import Foundation
import Moya
internal import Alamofire

enum AlbumAPI: TargetType {
    case albums
    
    var baseURL: URL {
        return Configuration.baseURL
    }
    
    var path: String {
        switch self {
        case .albums: return "/albums"
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
