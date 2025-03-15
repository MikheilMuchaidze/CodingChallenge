//
//  ContentView.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol
    private let testingURL = URL(string: "https://run.mocky.io/v3/9b27a9ff-886d-42b6-9501-950e1fd1598b")!

    // MARK: - Init

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    // MARK: - Body

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button("Network Test Button") {
                Task {
                    do {
                        let testData: Welcome = try await networkService.fetch(url: testingURL, method: .get)
                        print(testData)
                    } catch {
                        print(error)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview

//#Preview {
//    ContentView()
//}

struct Welcome: Codable {
    let type, title: String
    let items: [WelcomeItem]
}

struct WelcomeItem: Codable {
    let type, title: String
    let items: [ItemItem]
}

struct ItemItem: Codable {
    let type, title: String
    let src: String?
    let items: [ItemItem]?
}
