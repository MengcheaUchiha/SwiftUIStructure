//
//  UserItemView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 6/4/26.
//

import SwiftUI
import Kingfisher

struct UserItemView: View {
    var user: UserModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KFImage(URL(string: "https://m.media-amazon.com/images/I/71wbjqNASbL.jpg"))
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(user.username ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal)
    }
}

#Preview() {
    UserItemView(user: UserModel(id: 1, name: "Rany", username: "Rany", phone: "093747544"))
}
