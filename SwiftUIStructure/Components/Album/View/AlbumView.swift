//
//  AlbumView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

import SwiftUI

struct AlbumView: View {
    @StateObject private var viewModel = AlbumViewModel()
    
    var body: some View {
        AsyncContentView(
            source: viewModel,
            loadingView: {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.0, anchor: .center)
            }, errorView: { error in
                errorView(error: error.localizedDescription)
            }) { albums in
                contentView(for: albums)
            }
    }
}

extension AlbumView {
    
    func contentView(for items: [Album]) -> some View {
        return ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(items, id: \.id) { album in
                    AlbumItemView(album: album)
                }
            }
            .navigationTitle("Albums")
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
    AlbumView()
}
