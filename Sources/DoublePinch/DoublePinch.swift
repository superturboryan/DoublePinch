import SwiftUI

extension Button {
    
    nonisolated public func doublePinch(action: @escaping @MainActor () -> Void) -> some View {
        accessibilityQuickAction(style: .outline) {
            SwiftUI.Button("Magic Pinch", action: action)
        }
    }
}
