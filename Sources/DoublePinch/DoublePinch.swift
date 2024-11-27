//
//  DoublePinch.swift
//  DoublePinch
//

import OSLog
import SwiftUI
import TappableButton

private let log = Logger(subsystem: "com.doublepinch", category: "DoublePinchModifier")

extension Button {
    
    /// Adds a double-pinch gesture to the button, enabling actions to be triggered based on the specified mode.
    ///
    /// Use this modifier to configure a `Button` to respond to a double-pinch gesture, such as when an
    /// accessibility quick action or the newer Double Tap gesture is triggered. The action associated
    /// with the button will be executed when the double-pinch gesture is recognized.
    ///
    /// - Parameters:
    ///   - mode: The mode defining the types of double-pinch actions to handle. Defaults to `.automatic`,
    ///     which determines the most appropriate mode for the double-tap gesture.
    ///
    /// - Returns: A view modified to handle double-pinch gestures using the specified modes.
    ///
    /// ## Example
    /// ```swift
    /// Button("Tap Me") {
    ///     print("Button tapped!")
    /// }
    /// .doublePinch()
    /// ```
    ///
    /// - Note: If no action is found for the modifier, an error will be logged, and a fallback suggestion
    ///   to access `.accessibilityQuickAction` directly will be provided.
    ///
    /// - Warning: Ensure the action for the button is properly configured. If not, a fault will be logged,
    ///   and the action will not be executed.
    ///
    /// - Important: This method is marked as `@MainActor` to ensure that UI updates are performed on the main thread.
    @MainActor
    public func doublePinch(_ mode: DoublePinchMode = DoublePinchMode.automatic) -> some View {
        let modifier = DoublePinchViewModifier(mode: mode) {
            if !_performAction() {
                log.fault(
                    """
                    No action has been found for the double pinch modifier. Please file an issue on GitHub.
                    https://github.com/superturboryan/DoublePinch/issues
                    
                    Workaround: Use View/accessibilityQuickAction directly.
                    """
                )
            }
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
        if #available(watchOS 11.0, *), mode == .doubleTapGesture {
            content.handGestureShortcut(.primaryAction)
        } else if mode == .accessibilityQuickAction {
            content.accessibilityQuickAction(style: .outline) {
                Button("Primary action", action: action)
            }
        } else {
            content
        }
    }
}
