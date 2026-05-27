//
//  Configuration.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 7/4/26.
//

import Foundation

class Configuration {
    
    static var isPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
    
    static var baseURL: URL {
//        return URL(string: "https://jsonplaceholder.typicode.com")!
        return URL(string: EnvironmentConfig.shared.endPoint ?? "")!
    }
    
}
