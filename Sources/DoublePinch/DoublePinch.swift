//
//  DoublePinch.swift
//  DoublePinch
//

import os
import SwiftUI
import TappableButton

private let log = Logger(subsystem: "com.doublepinch", category: "DoublePinchModifier")

extension Button {
    
    @MainActor
    public func doublePinch(_ mode: DoublePinchMode = DoublePinchMode.automatic) -> some View {
        let modifier = DoublePinchViewModifier(mode: mode) {
            guard let _action else {
                log.fault(
                    """
                    No action has been found for the double pinch modifier. Please file an issue on GitHub.
                    https://github.com/superturboryan/DoublePinch/issues
                    
                    Workaround: Use View/accessibilityQuickAction directly.
                    """
                )
                return
            }
            MainActor.assumeIsolated(_action)
        }
        
        return self.modifier(modifier)
    }
}

private struct DoublePinchViewModifier: ViewModifier {
    
    let mode: DoublePinchMode
    let action: @MainActor () -> Void
    
    init(mode: DoublePinchMode, action: @escaping @MainActor () -> Void) {
        self.mode = mode
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content.accessibilityQuickAction(
            style: .outline,
            isActive: .constant(mode == .accessibilityQuickAction)
        ) {
            Button("Primary action", action: action)
        }
        .modifier(HandGestureShortcutModifier(mode: mode))
    }
}

private struct HandGestureShortcutModifier: ViewModifier {
    
    let mode: DoublePinchMode
    
    public func body(content: Content) -> some View {
        if #available(watchOS 11.0, *) {
            content.handGestureShortcut(.primaryAction, isEnabled: mode == .doubleTapGesture)
        } else {
            content
        }
    }
}
