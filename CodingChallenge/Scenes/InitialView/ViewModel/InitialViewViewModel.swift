//
//  InitialViewViewModel.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation
import Combine

protocol InitialViewViewModelProtocol {
    var initialLoading: Bool { get }

    func fetchTableOfContents() async
}

@Observable
final class InitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let tableOfContentsFetchingURL = URL(string: "https://run.mocky.io/v3/9b27a9ff-886d-42b6-9501-950e1fd1598b")

    // MARK: - Published Properties

    var initialLoading: Bool = true

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func fetchTableOfContents() async {
        guard let tableOfContentsFetchingURL else { return }
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let tableOfContentsModel: TableOfContentsModel? = try? await networkService.fetch(
            url: tableOfContentsFetchingURL,
            method: .get
        )
        Task { @MainActor in
            initialLoading = false
        }
    }
}
