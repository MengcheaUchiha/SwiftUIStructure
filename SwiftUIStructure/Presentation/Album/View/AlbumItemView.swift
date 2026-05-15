//
//  AlbumItemView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

import SwiftUI
import Kingfisher

struct AlbumItemView: View {
    let album: Album
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KFImage(URL(string: "https://i.pinimg.com/736x/c8/24/9e/c8249e07b0eab2cb5630ba657920c8a8.jpg"))
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(album.title ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    AlbumItemView(album: Album(id: 1, userId: 1, title: "Marany"))
}
