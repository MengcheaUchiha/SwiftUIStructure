//
//  ContentView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 5/4/26.
//

import SwiftUI
import FlowStacks
import Combine
import Moya

struct ContentView: View {
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @State var routes: [Route<AppRoute>] = []
    @State var selectedTab: Tab = .home
    
    var body: some View {
        FlowStack($routes, withNavigation: true) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(Tab.home)
                
                UserView()
                    .tabItem {
                        Label("Users", systemImage: "person")
                    }
                    .tag(Tab.users)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.2")
                    }
                    .tag(Tab.profile)
            }
            .flowDestination(for: AppRoute.self) { route in
                switch route {
                case .users:
                    UserView()
                    
                case .albums:
                    AlbumView()
                    
                case .detail(let user):
                    UserDetailView(user: user)
                    
                default:
                    fatalError("Home should not be presented again")
                }
            }
        }
        .onChange(of: routes) { print("ROUTES:", $0) }
        .onOpenURL { url in
            handleDeepLink(url)
        }
        .onReceive(deepLinkManager.$url.compactMap { $0 }) { url in
            handleDeepLink(url)
        }
    }
    
    func handleDeepLink(_ url: URL) {
        guard url.scheme == "myapp" else { return }
        
        print("Deeplink: \(url.host ?? "")")
        
        switch url.host {
        case "home":
            selectedTab = .home
            routes = [] // reset

            if url.pathComponents.count > 1,
               let id = Int(url.pathComponents.last!) {
                routes = [.push(.detail(user: UserModel(id: 1, name: "Rany", username: "Marany", phone: "0962900002")))]
            }

        case "profile":
            selectedTab = .profile
            routes = []
            
        case "users":
            routes = []
            routes = [.push(.users)]

        default:
            break
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(DeepLinkManager())
}
