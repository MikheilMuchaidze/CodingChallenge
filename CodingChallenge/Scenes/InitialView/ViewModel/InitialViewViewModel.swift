//
//  InitialViewViewModel.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation
import Combine
import SwiftUI

protocol InitialViewViewModelProtocol {
    var initialLoading: Bool { get }
    var title: String? { get }
    var items: [TableOfContentsSectionsModel]? { get }
    var displayCacheRemovalPopup: Bool { get set }

    func fetchTableOfContents() async
    func contentIsNilOrEmpty() -> Bool
    func removeDataFromCache()
    func refreshContent() async
}

@Observable
final class InitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    private let tableOfContentsFetchingURL = URL(string: "https://run.mocky.io/v3/9b27a9ff-886d-42b6-9501-950e1fd1598b")
    private var tableOfContentsModel: TableOfContentsModel = TableOfContentsModel()

    // MARK: - Published Properties

    var initialLoading = true
    var displayCacheRemovalPopup = false

    // MARK: - Shared Properties

    @ObservationIgnored var title: String? {
        tableOfContentsModel.title
    }

    @ObservationIgnored var items: [TableOfContentsSectionsModel]? {
        tableOfContentsModel.items
    }

    // MARK: - Init

    init(
        networkService: NetworkServiceProtocol = NetworkService(),
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()
    ) {
        self.networkService = networkService
        self.userDefaultsManager = userDefaultsManager
    }

    // MARK: - Methods

    func fetchTableOfContents() async {
        Task { @MainActor in
            initialLoading = true
        }
        guard let tableOfContentsFetchingURL else { return }
        if let cachedData: TableOfContentsModel = userDefaultsManager.get(forKey: .tableOfContents) {
            tableOfContentsModel = cachedData
            print("Loaded from cache")
            Task { @MainActor in
                initialLoading = false
            }
            return
        }

        try? await Task.sleep(nanoseconds: 2_000_000_000) // Just visual for not fetch instantly
        let tableOfContentsModelFromResponse: TableOfContentsModel? = try? await networkService.fetch(
            url: tableOfContentsFetchingURL,
            method: .get
        )
        if let tableOfContentsModelFromResponse {
            tableOfContentsModel = tableOfContentsModelFromResponse
            print("Loaded from API")
            saveToCache(tableOfContentsModelFromResponse)
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

        return tableOfContentsModelType.isEmpty
        && tableOfContentsModelTitle.isEmpty
        && tableOfContentsModelItems.isEmpty
    }

    func removeDataFromCache() {
        userDefaultsManager.clear()
        print("Data removed from cache")
        Task { @MainActor in
            displayCacheRemovalPopup = true
        }
    }

    func refreshContent() async {
        await fetchTableOfContents()
    }

    // MARK: - Private Methods

    private func saveToCache(_ data: TableOfContentsModel) {
        guard contentIsNilOrEmpty() == false else { return }
        userDefaultsManager.save(
            data,
            forKey: .tableOfContents
        )
        print("Save to cache")
    }
}
