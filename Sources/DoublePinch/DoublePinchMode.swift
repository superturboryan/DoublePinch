//
//  DoublePinchMode.swift
//  DoublePinch
//

import Foundation

/// A set of options representing different modes for handling the double tap (AKA double pinch) gesture on an Apple Watch.
///
/// The `DoublePinchMode` struct allows configuration of different action modes that can be triggered
/// by gestures or accessibility features. It supports determining available options dynamically
/// based on the device's capabilities.
public enum DoublePinchMode: Sendable {
    
    /// Represents the Accessibility Quick Action mode, available from watchOS 9.0 for the Series 4/SE and newer watch models.
    case accessibilityQuickAction
    
    /// Represents the hand gesture shortcut for the primary action, available from watchOS 11.0 for the Series 9 and newer watch models.
    ///
    /// On watchOS, this is performed by double-tapping the thumb and index finger together.
    ///
    /// Equivalent to `.handGestureShortcut(.primaryAction)`
    @available(watchOS 11.0, *)
    case doubleTapGesture
}

extension DoublePinchMode {
    
    /// The automatic mode determines the most appropriate mode for the double-tap gesture
    /// based on the availability of APIs (`watchOS 11.0` and later) and the compatibility
    /// of the device model (Apple Watch Series 9 or newer).
    ///
    /// - If the device supports the double-tap gesture (`watchOS 11.0+` and Series 9+),
    ///   the `doubleTapGesture` mode is returned.
    /// - Otherwise, the `accessibilityQuickAction` mode is used as a fallback.
    ///
    /// Use this property to dynamically adapt functionality to the user's device and OS.
    public static var automatic: DoublePinchMode {
        if #available(watchOS 11.0, *), DoublePinchMode.isDoubleTapGestureSupported {
            .doubleTapGesture
        } else {
            .accessibilityQuickAction
        }
    }
}

private extension DoublePinchMode {
    
    /// Indicates whether the device supports the double-tap gesture feature.
    ///
    /// The double-tap gesture is supported on Apple Watch Series 9/Ultra and newer. This determination
    /// is based on the device's model identifier.
    ///
    /// See a complete list of device models [here](https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt)
    static var isDoubleTapGestureSupported: Bool { // AKA isSeries9OrNewer
        // https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt
        guard let firstModelDigit = Int(String(describing: model.first)) else {
            return false
        }
        return firstModelDigit >= 7
    }
    
    /// Retrieves the model identifier of the device.
    ///
    /// This value is used internally to determine device capabilities.
    static var model: String {
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
