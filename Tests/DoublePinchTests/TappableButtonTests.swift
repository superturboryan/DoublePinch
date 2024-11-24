//
//  TappableButtonTests.swift
//  DoublePinch
//

import SwiftUI
import TappableButton
import Testing

struct TappableButtonTests {
    
    @MainActor
    @Test("Action can be performed programmatically", .timeLimit(.minutes(1)))
    func performAction() async throws {
        try await confirmation { confirm in
            let button = SwiftUI.Button("") { confirm() }
            let action = try #require(button._action)
            action()
        }
    }
}
