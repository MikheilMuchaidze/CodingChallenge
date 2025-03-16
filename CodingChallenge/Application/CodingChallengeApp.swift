//
//  CodingChallengeApp.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import SwiftUI

@main
struct CodingChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InitialViewConfigurator.configure()
            }
        }
    }
}
