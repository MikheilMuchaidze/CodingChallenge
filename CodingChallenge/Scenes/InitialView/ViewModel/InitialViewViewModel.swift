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
    var title: String? { get }
    var items: [TableOfContentsSectionsModel]? { get }

    func fetchTableOfContents() async
    func contentIsNilOrEmpty() -> Bool
}

@Observable
final class InitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let tableOfContentsFetchingURL = URL(string: "https://run.mocky.io/v3/9b27a9ff-886d-42b6-9501-950e1fd1598b")
    private var tableOfContentsModel: TableOfContentsModel = TableOfContentsModel()

    // MARK: - Published Properties

    var initialLoading: Bool = true

    // MARK: - Shared Properties

    @ObservationIgnored var title: String? {
        tableOfContentsModel.title
    }

    @ObservationIgnored var items: [TableOfContentsSectionsModel]? {
        tableOfContentsModel.items
    }

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func fetchTableOfContents() async {
        guard let tableOfContentsFetchingURL else { return }
        try? await Task.sleep(nanoseconds: 2_000_000_000) // Just visual for not fetch instantly
        let tableOfContentsModelFromResponse: TableOfContentsModel? = try? await networkService.fetch(
            url: tableOfContentsFetchingURL,
            method: .get
        )
        if let tableOfContentsModelFromResponse {
            tableOfContentsModel = tableOfContentsModelFromResponse
        }
        Task { @MainActor in
            initialLoading = false
        }
    }

    // If all content is empty then return true to show empty state in view
    func contentIsNilOrEmpty() -> Bool {
        guard
            let tableOfContentsModelType = tableOfContentsModel.type,
            let tableOfContentsModelTitle = tableOfContentsModel.title,
            let tableOfContentsModelItems = tableOfContentsModel.items
        else { return true }

        return !tableOfContentsModelType.isEmpty
        && !tableOfContentsModelTitle.isEmpty
        && !tableOfContentsModelItems.isEmpty
    }
}
