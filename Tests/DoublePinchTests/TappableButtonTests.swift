//
//  TappableButtonTests.swift
//  DoublePinch
//

import SwiftUI
import TappableButton
import Testing

struct TappableButtonTests {
    
    @Test("Action can be performed programmatically starting from watchOS 11.0", .timeLimit(.minutes(1)))
    @available(watchOS 11.0, *)
    @MainActor func performAction() async throws {
        try await assertAction()
    }
    
    @Test("Action can be performed programmatically before watchOS 11.0", .timeLimit(.minutes(1)))
    @available(watchOS, obsoleted: 11.0)
    func performAction2() async throws {
        try await assertAction()
    }
}

private extension TappableButtonTests {
    
    @MainActor private func assertAction() async throws {
        await confirmation { confirm in
            let button = SwiftUI.Button("") { confirm() }
            #expect(button._performAction() == true)
        }
    }
}
