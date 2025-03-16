//
//  InitialView.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import SwiftUI

struct InitialView: View {
    // MARK: - ViewModel

    @State var viewModel: InitialViewViewModelProtocol

    // MARK: - Init

    init(viewModel: InitialViewViewModelProtocol) {
        self._viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        Group {
            if viewModel.initialLoading {
                initialLoadingState
            } else {
                content
            }
        }
        .onLoad {
            Task {
                await viewModel.fetchTableOfContents()
            }
        }
        .navigationTitle("Table Of contents")
    }

    // MARK: - Body Properties

    private var initialLoadingState: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5, anchor: .center)

    }

    private var content: some View {
        Text("Hello, world!")
    }
}

// MARK: - Preview

#Preview {
    let previewViewModel = InitialViewViewModel()
    return InitialView(viewModel: previewViewModel)
}
