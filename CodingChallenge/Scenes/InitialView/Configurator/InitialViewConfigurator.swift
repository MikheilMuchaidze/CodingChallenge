//
//  InitialViewConfigurator.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import Foundation

enum InitialViewConfigurator {
    static func configure() -> InitialView {
        let initialViewViewModel = InitialViewViewModel()
        let initialView = InitialView(viewModel: initialViewViewModel)
        return initialView
    }
}
