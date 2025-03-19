//
//  MockedTableOfContents.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 20.03.25.
//

extension TableOfContentsModel {
    static let mockedTableOfContents = TableOfContentsModel(
        type: "page",
        title: "Main Page",
        items: [
            TableOfContentsSectionsModel(
                type: "section",
                title: "Introduction",
                items: [
                    TableOfContentsSectionsModel(
                        type: "text",
                        title: "Welcome to the main page!"
                    ),
                    TableOfContentsSectionsModel(
                        type: "image",
                        title: "Welcome Image",
                        src: "https://robohash.org/280?&set=set4&size=400x400"
                    )
                ]
            ),
            TableOfContentsSectionsModel(
                type: "section",
                title: "Chapter 1",
                items: [
                    TableOfContentsSectionsModel(
                        type: "text",
                        title: "This is the first chapter."
                    ),
                    TableOfContentsSectionsModel(
                        type: "section",
                        title: "Subsection 1.1",
                        items: [
                            TableOfContentsSectionsModel(
                                type: "text",
                                title: "This is a subsection under Chapter 1."
                            ),
                            TableOfContentsSectionsModel(
                                type: "image",
                                title: "Chapter 1 Image",
                                src: "https://robohash.org/100?&set=set4&size=400x400"
                            )
                        ]
                    )
                ]
            ),
            TableOfContentsSectionsModel(
                type: "page",
                title: "Second Page",
                items: [
                    TableOfContentsSectionsModel(
                        type: "section",
                        title: "Chapter 2",
                        items: [
                            TableOfContentsSectionsModel(
                                type: "text",
                                title: "This is the second chapter."
                            ),
                            TableOfContentsSectionsModel(
                                type: "text",
                                title: "What is the main topic of Chapter 2?"
                            )
                        ]
                    )
                ]
            )
        ]
    )
}
