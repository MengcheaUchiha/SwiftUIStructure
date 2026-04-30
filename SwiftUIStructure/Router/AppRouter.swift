//
//  AppRouter.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 13/4/26.
//

import FlowStacks
import Foundation

enum Tab: String, CaseIterable {
    case home
    case users
    case profile
    
    var title: String {
        rawValue.capitalized
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .users: return "doc.text.fill"
        case .profile: return "doc.text.fill"
        }
    }
}

enum AppRoute: Hashable {
    case home
    case users
    case albums
    case detail(user: UserModel)
}
