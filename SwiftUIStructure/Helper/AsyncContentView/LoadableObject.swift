//
//  LoadableObject.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

// MARK: - Ref: https://github.com/CypherPoet/SwiftUIAsyncContentView

import Foundation

@MainActor
public protocol LoadableObject: ObservableObject {
    associatedtype Output
    
    var state: LoadingState<Output> { get }
    
    func load() async
}
