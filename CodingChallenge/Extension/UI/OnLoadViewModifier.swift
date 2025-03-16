//
//  OnLoadViewModifier.swift
//  CodingChallenge
//
//  Created by Mikheil Muchaidze on 16.03.25.
//

import SwiftUI

public struct OnLoadViewModifier: ViewModifier {
    @State private var loaded = false
    private let action: (() -> Void)?

    init(action: (() -> Void)?) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                if !loaded {
                    loaded = true
                    action?()
                }
            }
    }
}

public extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(OnLoadViewModifier(action: action))
    }
}
