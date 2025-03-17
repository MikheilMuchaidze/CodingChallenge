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
                emptyState
            } else {
                content
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) {
                Button {
                    Task {
                        await viewModel.refreshContent()
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .symbolEffect(.rotate, options: .speed(3.0), isActive: viewModel.initialLoading)
                }
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    viewModel.removeDataFromCache()
                } label: {
                    Image(systemName: "externaldrive.fill.badge.xmark")
                }
                .disabled(viewModel.contentIsNilOrEmpty())
            }
        }
        .alert(isPresented: $viewModel.displayCacheRemovalPopup) {
            Alert(
                title: Text("Cache removed"),
                message: Text("Cache removed from user defaults, please refresh"),
                dismissButton: .default(Text("OK"), action: {
                    viewModel.displayCacheRemovalPopup = false
                })
            )
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
        List {
            Text("Content")
        }
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
        Text("Sorry empty data :(")
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        let previewViewModel = InitialViewViewModel()
        return InitialView(viewModel: previewViewModel)
    }
}
