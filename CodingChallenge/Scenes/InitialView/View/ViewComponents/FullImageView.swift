//
//  FullImageView.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 20.03.25.
//

import SwiftUI

struct FullImageView: View {
    // MARK: - Private Properties

    private let imageURL: String
    private let title: String

    @Environment(\.dismiss) private var dismiss

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
        NavigationView {
            VStack {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "xmark")
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}
