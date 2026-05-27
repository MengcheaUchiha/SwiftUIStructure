//
//  SwiftUIStructureApp.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import SwiftUI

@main
struct SwiftUIStructureApp: App {
    @StateObject private var deepLinkManager = DeepLinkManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(deepLinkManager)
                .onAppear {
                    EnvironmentConfig.shared.logConfiguration()
                    let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
                    print("Configuration: \(currentConfiguration)")
                }
        }
    }
}
