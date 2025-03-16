//
//  TableOfContentsModel.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation

struct TableOfContentsModel: Decodable {
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

struct TableOfContentsSectionsModel: Decodable {
    let type: String?
    let title: String?
    let items: [TableOfContentsPagesModel]?

    init(
        type: String? = nil,
        title: String? = nil,
        items: [TableOfContentsPagesModel]? = nil
    ) {
        self.type = type
        self.title = title
        self.items = items
    }
}

struct TableOfContentsPagesModel: Decodable {
    let type: String?
    let title: String?
    let src: String?
    let items: [TableOfContentsPagesModel]?

    init(
        type: String? = nil,
        title: String? = nil,
        src: String? = nil,
        items: [TableOfContentsPagesModel]? = nil
    ) {
        self.type = type
        self.title = title
        self.src = src
        self.items = items
    }
}
