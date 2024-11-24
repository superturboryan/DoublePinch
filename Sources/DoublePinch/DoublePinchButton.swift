//
//  DoublePinchButton.swift
//  DoublePinch
//

import SwiftUI
import WatchKit

struct DoublePinchButton<Label: View>: View {
    
    let mode: DoublePinchMode
    
    private let action: () -> Void
    private let label: () -> Label
    
    init(
        mode: DoublePinchMode = .all,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.mode = mode
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action, label: label)
            .doublePinch(mode)
    }
}
