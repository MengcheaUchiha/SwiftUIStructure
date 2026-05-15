//
//  HomeView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 13/4/26.
//

import SwiftUI
import FlowStacks

struct HomeView: View {
    @EnvironmentObject var navigator: FlowNavigator<AppRoute>
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    
    var body: some View {
        VStack {
            Button {
                navigator.push(.users)
            } label: {
                Text("Navigate: -> Users")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button {
                deepLinkManager.open("myapp://users")
            } label: {
                Text("Deeplink: myapp://users")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button {
                navigator.push(.albums)
            } label: {
                Text("Navigate: -> Albums")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
//            Button {
//                deepLinkManager.open("myapp://users")
//            } label: {
//                Text("Deeplink: myapp://users")
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    HomeView()
}
