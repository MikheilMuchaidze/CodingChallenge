//
//  ContentItemView.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 20.03.25.
//

import SwiftUI

struct ContentItemView: View {
    // MARK: - Private Properties

    private let item: TableOfContentsSectionsModel
    private let depth: Int

    // MARK: - Init

    init(
        item: TableOfContentsSectionsModel,
        depth: Int
    ) {
        self.item = item
        self.depth = depth
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title with appropriate font size based on type and depth
            if let title = item.title, let type = item.type, type != "image" {
                Text(title)
                    .font(fontForItem(type: type, depth: depth))
                    .fontWeight(fontWeightForItem(type: type, depth: depth))
            }

            // Render based on type
            if let type = item.type {
                switch type {
                case "image":
                    if let imageURL = item.src {
                        ImageContentView(
                            imageURL: imageURL,
                            title: item.title ?? ""
                        )
                            .frame(height: 150)
                    }
                default:
                    EmptyView()
                }
            }

            // Recursively render child items if they exist
            if let items = item.items {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(items) { childItem in
                        ContentItemView(
                            item: childItem,
                            depth: depth + 1
                        )
                            .padding(.leading, 16)
                    }
                }
            }
        }
    }

    private func fontForItem(
        type: String,
        depth: Int
    ) -> Font {
        switch type {
        case "page":
                .title
        case "section":
            switch depth {
            case 0:
                    .title2
            case 1:
                    .title3
            default:
                    .headline
            }
        case "text":
                .body
        default:
                .body
        }
    }

    private func fontWeightForItem(
        type: String,
        depth: Int
    ) -> Font.Weight {
        switch type {
        case "page":
                .bold
        case "section":
                .semibold
        default:
                .regular
        }
    }
}
