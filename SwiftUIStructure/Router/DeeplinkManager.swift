//
//  DeeplinkManager.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 13/4/26.
//

import SwiftUI
import Combine

@MainActor
final class DeepLinkManager: ObservableObject {
    @Published var url: URL?

    func open(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        self.url = url
    }
}
