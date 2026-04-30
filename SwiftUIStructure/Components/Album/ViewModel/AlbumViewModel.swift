//
//  AlbumViewModel.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

import Moya
import Foundation
import Combine

@MainActor
final class AlbumViewModel: LoadableObject {
    @Published private(set) var state = LoadingState<[Album]>.idle
    @Published var loadedAlbums: [Album] = []
    
    private lazy var provider = MoyaProvider<AlbumAPI>()
    
    func load() async {
        if Configuration.isPreview {
            state = .loaded([
                Album(id: 1, userId: 1, title: "Marany"),
                Album(id: 1, userId: 1, title: "Lolita")
            ])
            return
        }
        
        if case .idle = state {
            state = .loading
        }
        
//        Swift.Task {
            do {
                let response = try await provider.request(.albums)
                let albums = try response.map([Album].self)
                loadedAlbums = loadedAlbums + albums
                state = .loaded(albums)
                print("Users: \(albums.count)")
            } catch {
                print("Error: \(error.localizedDescription)")
                state = .failed(error)
            }
//        }
    }
    
}
