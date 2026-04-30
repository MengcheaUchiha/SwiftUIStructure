//
//  AsyncContentView.swift
//  SwiftUIStructure
//
//  Created by Mengchea Saro on 20/4/26.
//

// MARK: - Ref: https://github.com/CypherPoet/SwiftUIAsyncContentView
    
import SwiftUI

public struct AsyncContentView<
    SourceObject: LoadableObject,
    LoadingView: View,
    ErrorView: View,
    Content: View
> {
    public typealias DefaultLoadingView = ProgressView<EmptyView, EmptyView>
    public typealias LoadingViewBuilder = (() -> LoadingView)

    public typealias DefaultErrorView = EmptyView
    public typealias ErrorViewBuilder = ((Error) -> ErrorView)
    
    public typealias ContentViewBuilder = ((SourceObject.Output) -> Content)
    
    
    @ObservedObject
    var source: SourceObject
    
    var loadingView: LoadingViewBuilder
    var errorView: ErrorViewBuilder
    var content: ContentViewBuilder
    
    
    // MARK: -  Init
    public init(
        source: SourceObject,
        @ViewBuilder loadingView: @escaping LoadingViewBuilder,
        @ViewBuilder errorView: @escaping ErrorViewBuilder,
        @ViewBuilder content: @escaping ContentViewBuilder
    ) {
        self.source = source
        self.loadingView = loadingView
        self.errorView = errorView
        self.content = content
    }
}


// MARK: - `View` Body
extension AsyncContentView: View {

    public var body: some View {
        Group {
            switch source.state {
            case .idle:
                Color.clear
            case .loading:
                loadingView()
            case .failed(let error):
                errorView(error)
            case .loaded(let output):
                content(output)
            }
        }
        .onFirstAppear {
            if case .idle = source.state {
                load()
            }
        }
    }
    
    private func load() {
        Task {
            await source.load()
        }
    }
}

extension AsyncContentView where
    LoadingView == DefaultLoadingView
{
    /// Initializes an ``AsyncContentView`` with a default loading view.
    public init(
        source: SourceObject,
        @ViewBuilder errorView: @escaping ErrorViewBuilder,
        @ViewBuilder content: @escaping ContentViewBuilder
    ) {
        self.init(
            source: source,
            loadingView: { LoadingView() },
            errorView: errorView,
            content: content
        )
    }
}


extension AsyncContentView where
    ErrorView == DefaultErrorView
{
    /// Initializes an ``AsyncContentView`` with a default error view.
    public init(
        source: SourceObject,
        @ViewBuilder loadingView: @escaping LoadingViewBuilder,
        @ViewBuilder content: @escaping ContentViewBuilder
    ) {
        self.init(
            source: source,
            loadingView: loadingView,
            errorView: { _ in ErrorView() },
            content: content
        )
    }
}


extension AsyncContentView where
    LoadingView == DefaultLoadingView,
    ErrorView == DefaultErrorView
{
    /// Initializes an ``AsyncContentView`` with a default loading view
    /// and default error view.
    public init(
        source: SourceObject,
        @ViewBuilder content: @escaping ContentViewBuilder
    ) {
        self.init(
            source: source,
            loadingView: { LoadingView() },
            errorView: { _ in ErrorView() },
            content: content
        )
    }
}
