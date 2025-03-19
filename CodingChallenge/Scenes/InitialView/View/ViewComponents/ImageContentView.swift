//
//  ImageContentView.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 20.03.25.
//

import SwiftUI

struct ImageContentView: View {
    // MARK: - Private Properties

    private let imageURL: String
    private let title: String

    @State private var showFullImage = false

    // MARK: - Init

    init(
        imageURL: String,
        title: String
    ) {
        self.imageURL = imageURL
        self.title = title
    }

    // MARK: - Body

    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                        .onTapGesture {
                            showFullImage = true
                        }
                case .failure:
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxHeight: 150)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .sheet(isPresented: $showFullImage) {
            FullImageView(imageURL: imageURL, title: title)
        }
    }
}
