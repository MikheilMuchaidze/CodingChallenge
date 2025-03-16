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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    let previewViewModel = InitialViewViewModel()
    return InitialView(viewModel: previewViewModel)
}
