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
            } else if viewModel.contentIsNilOrEmpty() {
                content
            } else {
                emptyState
            }
        }
        .onLoad {
            Task {
                await viewModel.fetchTableOfContents()
            }
        }
        .navigationTitle("Table Of contents")
    }
}

// MARK: - Content

private extension InitialView {
    var content: some View {
        Text("Content")
    }
}

// MARK: - Loading State View

private extension InitialView {
    var initialLoadingState: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5, anchor: .center)
    }
}

// MARK: - Empty State View

private extension InitialView {
    var emptyState: some View {
        Text("Sorry no data :(")
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        let previewViewModel = InitialViewViewModel()
        return InitialView(viewModel: previewViewModel)
    }
}
