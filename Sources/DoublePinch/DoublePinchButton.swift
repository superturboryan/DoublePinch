//
//  DoublePinchButton.swift
//  DoublePinch
//

import SwiftUI
import WatchKit
/// A wrapper around the standard ``SwiftUI/Button`` that responds to a double-pinch gesture, supporting different gesture modes.
///
/// Use `DoublePinchButton` to create a button that can trigger actions in response to a double-pinch gesture,
/// such as accessibility quick actions or gestures available on newer Apple Watch models. This struct
/// encapsulates the functionality of a standard SwiftUI `Button` while adding double-pinch gesture support.
///
/// - Generic Parameter:
///   - `Label`: The type of the view that represents the label of the button.
///
/// ## Example
/// ```swift
/// DoublePinchButton(mode: .accessibilityQuickAction) {
///     print("Action triggered!")
/// } label: {
///     Text("Double Pinch Me")
/// }
/// ```
///
/// - Parameters:
///   - mode: The mode(s) defining the types of double-pinch actions to handle. Defaults to `.all`,
///     which includes all supported modes for the current device.
///   - action: The action to perform when the button is tapped or the double-pinch gesture is recognized.
///     This action is executed on the main thread.
///   - label: A view builder that provides the button's visual content.
///
/// - Note: The double-pinch gesture support is added via the `.doublePinch(_:)` modifier.
struct DoublePinchButton<Label: View>: View {
    
    let mode: DoublePinchMode
    
    private let action: () -> Void
    private let label: () -> Label
    
    init(
        mode: DoublePinchMode = DoublePinchMode.automatic,
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
