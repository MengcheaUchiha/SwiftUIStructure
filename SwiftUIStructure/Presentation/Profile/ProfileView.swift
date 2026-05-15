//
//  ProfileView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 13/4/26.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            KFImage(URL(string: "https://m.media-amazon.com/images/I/71wbjqNASbL.jpg"))
                .loadDiskFileSynchronously(false)
                .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 60, height: 60)))
                .scaleFactor(UIScreen.main.scale)
                .placeholder {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Rany")
                    .font(.title3)
                    .fontWeight(.bold)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
}
