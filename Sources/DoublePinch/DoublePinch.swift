//
//  DoublePinch.swift
//  DoublePinch
//

import os
import SwiftUI
import TappableButton

public struct DoublePinchMode: OptionSet, Sendable {
    
    public let rawValue: UInt
    
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
    
    public static let accessibilityQuickAction = DoublePinchMode(rawValue: 1 << 0)
    
    @available(watchOS 11.0, *)
    public static let doubleTapGesture = DoublePinchMode(rawValue: 1 << 1)
    
    public static var all: DoublePinchMode {
        if #available(watchOS 11.0, *), DoublePinchMode.isDoubleTapGestureSupported {
            [.doubleTapGesture, .accessibilityQuickAction]
        } else {
            .accessibilityQuickAction
        }
    }
    
    static var isDoubleTapGestureSupported: Bool { // AKA isSeries9OrNewer
        // https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt
        guard let firstModelDigit = Int(String(describing: model.first)) else {
            return false
        }
        return firstModelDigit >= 7
    }
    
    private static var model: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let machineMirror = Mirror(reflecting: sysinfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}

private let log = Logger(subsystem: "com.doublepinch", category: "DoublePinchModifier")

extension Button {
    
    @MainActor
    public func doublePinch(_ mode: DoublePinchMode = .all) -> some View {
        let modifier = DoublePinchViewModifier(mode: mode) {
            guard let _action else {
                log.fault(
                    """
                    No action has been found for the double pinch modifier. Please file an issue on GitHub.
                    https://github.com/superturboryan/DoublePinch/issues
                    
                    Workaround: View/accessibilityQuickAction directly.
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
            isActive: .constant(mode.contains(.accessibilityQuickAction))
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
            content.handGestureShortcut(.primaryAction, isEnabled: mode.contains(.doubleTapGesture))
        } else {
            content
        }
    }
}
