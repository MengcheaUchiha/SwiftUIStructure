//
//  PhotosViewModel.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import Foundation
import Combine
import Moya
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
//    private lazy var provider = MoyaProvider<UserAPI>()
    
    private let userUseCase: UsersUseCase

    init(userUseCase: UsersUseCase) {
        self.userUseCase = userUseCase
    }
    
    func getUsers() {
        isLoading = true
        if Configuration.isPreview {
            users = [
                UserModel(id: 1, name: "Marany", username: "Rany", phone: "0962900002"),
                UserModel(id: 2, name: "Lolita", username: "Lolita", phone: "0962900002"),
                UserModel(id: 3, name: "Benedatta", username: "Benedatta", phone: "0962900002"),
                UserModel(id: 4, name: "Hehe", username: "Hikhik", phone: "0962900002")
            ]
            isLoading = false
            return
        }
        
//        Swift.Task {
//            do {
//                let response = try await provider.request(.users)
//                users = try response.map([UserModel].self)
//                print("Users: \(users.count)")
//                isLoading = false
//            } catch {
//                print("Error: \(error.localizedDescription)")
//                self.error = error.localizedDescription
//                isLoading = false
//            }
//        }
        
        Swift.Task {
            do {
                let users = try await userUseCase.fetchUsers()
                self.users = users
                isLoading = false
            } catch {
                print("Error: \(error.localizedDescription)")
                self.error = error.localizedDescription
                isLoading = false
            }
        }
        
    }
    
}
