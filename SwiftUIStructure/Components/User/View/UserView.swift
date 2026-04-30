//
//  UserView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import SwiftUI
import Kingfisher
import FlowStacks
import Moya


struct UserView: View {
    @EnvironmentObject var navigator: FlowNavigator<AppRoute>
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        ZStack {
            contentView(for: viewModel.users)
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(2.0, anchor: .center)
            }
            
            if let error = viewModel.error {
                errorView(error: error)
            }
        }
        .onFirstAppear {
            viewModel.getUsers()
        }
    }
    
}

extension UserView {
    
    func contentView(for items: [UserModel]) -> some View {
        return ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.id) { user in
                    Button {
                        navigator.push(.detail(user: user))
                    } label: {
                        UserItemView(user: user)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
    
    func errorView(error: String) -> some View {
        return VStack {
            Text("Something went wrong.")
                .font(.title3)
                .foregroundColor(.red)
            
            Text(error)
        }
    }
    
}

#Preview {
//    UserView(viewModel: UserViewModel(provider: MoyaProvider<UserAPI>()))
    UserView()
}

