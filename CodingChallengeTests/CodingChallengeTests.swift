//
//  CodingChallengeTests.swift
//  CodingChallengeTests
//
//  Created by Mikheil Muchaidze on 15.03.25.
//

import Testing
@testable import CodingChallenge

struct CodingChallengeTests {
    @Test
    func shouldDoTestComparisonWhenInitiated() {
        // Given
        let firstString = "Apple"
        let secondString = "Banana"

        // Then
        #expect(firstString != secondString)
    }
}
