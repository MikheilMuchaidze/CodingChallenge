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
    var initialLoading: Bool { get set }
    var title: String? { get }
    var items: [TableOfContentsSectionsModel]? { get }
    var displayCacheRemovalPopup: Bool { get set }
    var displayAPIError: Bool { get set }
    var apiErrorMessage: String { get }
    var errorMode: Bool { get set }

    var isRemoveCacheButtonDisabled: Bool { get set }

    func fetchTableOfContents() async
    func contentIsNilOrEmpty() -> Bool

    func refreshDataToolbarButtonTapped() async
    func removeDataFromCacheToolbarButtonTapped()
    func useCachedDataDuringErrorButtonTapped()
}

@Observable
final class InitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    private let tableOfContentsFetchingURL: URL
    private var tableOfContentsModel: TableOfContentsModel

    // MARK: - Published Properties
    
    var initialLoading = true
    var displayCacheRemovalPopup = false
    var displayAPIError = false
    var errorMode = false
    var isRemoveCacheButtonDisabled = true

    // MARK: - Shared Properties

    @ObservationIgnored var title: String? {
        tableOfContentsModel.title
    }

    @ObservationIgnored var items: [TableOfContentsSectionsModel]? {
        tableOfContentsModel.items
    }

    @ObservationIgnored var apiErrorMessage: String = ""

    // MARK: - Init

    init(
        tableOfContentsModel: TableOfContentsModel = TableOfContentsModel(),
        networkService: NetworkServiceProtocol = NetworkService(),
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(),
        tableOfContentsFetchingURL: URL = URL(string: "https://run.mocky.io/v3/d403fba7-413f-40d8-bec2-afe6ef4e201e")! // As we now it exists force unwrapping is fine
    ) {
        self.tableOfContentsModel = tableOfContentsModel
        self.networkService = networkService
        self.userDefaultsManager = userDefaultsManager
        self.tableOfContentsFetchingURL = tableOfContentsFetchingURL
    }

    // MARK: - Methods

    func fetchTableOfContents() async {
        updateViewLoadingState(true)

        await uiDelayForTesting(for: 1.0)
        do {
            if errorMode {
                throw NetworkErrorEntity.invalidURL
            }
            let tableOfContentsModelFromResponse: TableOfContentsModel? = try await networkService.fetch(
                url: tableOfContentsFetchingURL,
                method: .get
            )
            if let tableOfContentsModelFromResponse {
                tableOfContentsModel = tableOfContentsModelFromResponse
                print("Loaded from API")
                saveToCache(tableOfContentsModelFromResponse)
            }
        } catch let error as NetworkErrorEntity {
            handleNetworkError(error)
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
        updateViewLoadingState(false)
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

    func refreshDataToolbarButtonTapped() async {
        await fetchTableOfContents()
    }

    func removeDataFromCacheToolbarButtonTapped() {
        removeDataFromCache()
    }

    func useCachedDataDuringErrorButtonTapped() {
        guard let cachedData: TableOfContentsModel = userDefaultsManager.get(forKey: .tableOfContents) else { return }
        tableOfContentsModel = cachedData
        print("Loaded from cache")
        Task { @MainActor in
            displayAPIError = false
        }
        updateViewLoadingState(false)
    }
}

// MARK: - UI update methods

private extension InitialViewViewModel {
    // Just visual for not fetch instantly
    func uiDelayForTesting(for seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }

    func updateViewLoadingState(_ to: Bool) {
        Task { @MainActor in
            initialLoading = to
        }
    }
}

// MARK: - Error handling methods

private extension InitialViewViewModel {
    // Error Handling
    func handleNetworkError(_ error: NetworkErrorEntity) {
        print("❌Error mode error print")
        apiErrorMessage = switch error {
        case .invalidURL:
            "Invalid URL error"
        case .requestFailed(let error):
            "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            "Invalid response from server"
        case .decodingFailed(let error):
            "Decoding error: \(error.localizedDescription)"
        case .serverError(let statusCode, _):
            "Server error with status code: \(statusCode)"
        case .noInternet:
            "No internetConnection"
        case .timeout:
            "Server timeout"
        }
        Task { @MainActor in
            displayAPIError = true
        }
    }
}

// MARK: - Cache handling methods

private extension InitialViewViewModel {
    func saveToCache(_ data: TableOfContentsModel) {
        guard contentIsNilOrEmpty() == false else { return }
        userDefaultsManager.save(
            data,
            forKey: .tableOfContents
        )
        Task { @MainActor in
            isRemoveCacheButtonDisabled = false
        }
        print("Save to cache")
    }

    func removeDataFromCache() {
        userDefaultsManager.clear()
        print("Data removed from cache")
        tableOfContentsModel = TableOfContentsModel()
        Task { @MainActor in
            displayCacheRemovalPopup = true
            isRemoveCacheButtonDisabled = true
        }
    }
}

struct MockedInitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let userDefaultsManager: UserDefaultsManagerProtocol
    private let tableOfContentsFetchingURL: URL
    private var tableOfContentsModel: TableOfContentsModel

    // MARK: - Published Properties

    var initialLoading = false
    var displayCacheRemovalPopup = false
    var displayAPIError = false
    var errorMode = false
    var isRemoveCacheButtonDisabled = true

    // MARK: - Shared Properties

    @ObservationIgnored var title: String? {
        tableOfContentsModel.title
    }

    @ObservationIgnored var items: [TableOfContentsSectionsModel]? {
        tableOfContentsModel.items
    }

    @ObservationIgnored var apiErrorMessage: String = ""

    // MARK: - Init

    init(
        tableOfContentsModel: TableOfContentsModel = .mockedTableOfContents,
        networkService: NetworkServiceProtocol = NetworkService(),
        userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager(),
        tableOfContentsFetchingURL: URL = URL(string: "https://run.mocky.io/v3/d403fba7-413f-40d8-bec2-afe6ef4e201e")!
    ) {
        self.tableOfContentsModel = tableOfContentsModel
        self.networkService = networkService
        self.userDefaultsManager = userDefaultsManager
        self.tableOfContentsFetchingURL = tableOfContentsFetchingURL
    }

    // MARK: - Methods

    func fetchTableOfContents() async {}
    func contentIsNilOrEmpty() -> Bool { false }
    func refreshDataToolbarButtonTapped() async {}
    func removeDataFromCacheToolbarButtonTapped() {}
    func useCachedDataDuringErrorButtonTapped() {}
}
