//
//  UserDetailView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 13/4/26.
//

import SwiftUI

struct UserDetailView: View {
    let user: UserModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("ID: \(user.id)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Username: \(user.username ?? "")")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Name: \(user.name ?? "")")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("Phone: \(user.phone ?? "")")
                .font(.title3)
                .fontWeight(.bold)
        }
    }
}

#Preview {
    UserDetailView(user: UserModel(id: 1, name: "Rany", username: "Marany", phone: "0962900002"))
}
