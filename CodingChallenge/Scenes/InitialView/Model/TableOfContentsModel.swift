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
    let items: [Sections]
}

struct Sections: Decodable {
    let type: String?
    let title: String?
    let items: [Pages]
}

struct Pages: Decodable {
    let type: String?
    let title: String?
    let src: String?
    let items: [Pages]?
}
