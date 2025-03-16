//
//  InitialViewViewModel.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation
import Combine

protocol InitialViewViewModelProtocol {
    func fetchTableOfContents()
}

@Observable
final class InitialViewViewModel: InitialViewViewModelProtocol {
    // MARK: - Private Prop

    private let networkService: NetworkServiceProtocol

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Methods

    func fetchTableOfContents() {
    }
}
