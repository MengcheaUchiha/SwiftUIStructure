//
//  EnvironmentConfig.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 27/5/26.
//

import Foundation

final class EnvironmentConfig {
        
    enum Environment: String {
        case dev = "DEV"
        case staging = "STAGING"
        case prod = "PROD"
    }
    
    static let standard = EnvironmentConfig()
    
    var environment: Environment {
//        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String else { return .dev }
//        print("Current: \(currentConfiguration)")
        
        guard let appEnv = Bundle.main.infoDictionary?["APP_ENV"] as? String else { return .dev }
        let env = Environment(rawValue: appEnv)
        return env ?? .dev
    }
    
    var environments: Environment {
        #if DEV
            return .dev
        #elseif STAGING
            return .staging
        #elseif PROD
            return .prod
        #else
            return .dev
        #endif
    }
    
    var endPoint: String? {
        guard let endPoint = Bundle.main.infoDictionary?["END_POINT"] as? String else { return nil }
        return endPoint
    }
    
    func logConfiguration() {
        print("APP_ENV: \( self.environment.rawValue)")
        print("APP_ENV: \( self.environments.rawValue)")
        print("END_POINT: \(self.endPoint ?? "")")
        print("CFBundleDisplayName: \((Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? "")")
    }
}
