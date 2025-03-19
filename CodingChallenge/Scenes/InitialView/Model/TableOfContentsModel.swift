//
//  TableOfContentsModel.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation

struct TableOfContentsModel: Codable {
    let type: String?
    let title: String?
    let items: [TableOfContentsSectionsModel]?

    init(
        type: String? = nil,
        title: String? = nil,
        items: [TableOfContentsSectionsModel]? = nil
    ) {
        self.type = type
        self.title = title
        self.items = items
    }
}

struct TableOfContentsSectionsModel: Codable, Identifiable {
    let id = UUID()
    let type: String?
    let title: String?
    let src: String?
    let items: [TableOfContentsSectionsModel]?

    enum CodingKeys: String, CodingKey {
        case type, title, src, items
    }

    init(
        type: String? = nil,
        title: String? = nil,
        src: String? = nil,
        items: [TableOfContentsSectionsModel]? = nil
    ) {
        self.type = type
        self.title = title
        self.src = src
        self.items = items
    }

    // Custom coding to handle the UUID which isn't in the JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        src = try container.decodeIfPresent(String.self, forKey: .src)
        items = try container.decodeIfPresent([TableOfContentsSectionsModel].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(type, forKey: .type)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(src, forKey: .src)
        try container.encodeIfPresent(items, forKey: .items)
    }
}

struct ContentItem: Identifiable, Decodable {
    let id = UUID()
    let type: String
    let title: String
    var src: String?
    var items: [ContentItem]?

    enum CodingKeys: String, CodingKey {
        case type, title, src, items
    }
}
