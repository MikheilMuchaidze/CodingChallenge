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
        let _ = Self._printChanges()
        Group {
            if viewModel.initialLoading {
                initialLoadingState
            } else if viewModel.contentIsNilOrEmpty() {
                noContent
            } else {
                content
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarLeading) { // For refresh action
                Button {
                    Task {
                        await viewModel.refreshDataToolbarButtonTapped()
                    }
                } label: {
                    Image(systemName: "arrow.trianglehead.clockwise")
                        .symbolEffect(.rotate, options: .speed(3.0), isActive: viewModel.initialLoading)
                }
            }
            ToolbarItemGroup(placement: .topBarLeading) { // For activating error mode
                Toggle("ErrorMode", isOn: $viewModel.errorMode)
            }
            ToolbarItemGroup(placement: .topBarTrailing) { // For removing cache
                Button {
                    viewModel.removeDataFromCacheToolbarButtonTapped()
                } label: {
                    Image(systemName: "externaldrive.fill.badge.xmark")
                }
                .disabled(viewModel.isRemoveCacheButtonDisabled)
            }
        }
        .alert(isPresented: $viewModel.displayCacheRemovalPopup) { // For handling a message from cleared cache)
            Alert(
                title: Text("Cache/Data removed"),
                message: Text("Cache removed from user defaults and data from view"),
                dismissButton: .default(Text("OK"), action: {})
            )
        }
        .alert( // For displaying error
            "API Error",
            isPresented: $viewModel.displayAPIError,
            presenting: viewModel.apiErrorMessage
        ) { details in
            Button("Retry") {
                Task {
                    await viewModel.fetchTableOfContents()
                }
            }
            if viewModel.isRemoveCacheButtonDisabled == false {
                Button("Used cached data") {
                    viewModel.useCachedDataDuringErrorButtonTapped()
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: { errorMessage in
            Text(errorMessage)
        }
        .onLoad {
            Task {
                await viewModel.fetchTableOfContents()
            }
        }
    }
}

// MARK: - Content

private extension InitialView {
    var content: some View {
        List {
            VStack(alignment: .leading, spacing: 16) {
                if let title = viewModel.title {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                }
                
                if let items = viewModel.items {
                    ForEach(items) { item in
                        ContentItemView(item: item, depth: 0)
                    }
                }
            }
            .padding()
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
    var noContent: some View {
        Text("Sorry no content:(")
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        let previewViewModel = MockedInitialViewViewModel()
        return InitialView(viewModel: previewViewModel)
    }
}
