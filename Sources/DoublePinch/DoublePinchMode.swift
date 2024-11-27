//
//  DoublePinchMode.swift
//  DoublePinch
//

import Foundation

public enum DoublePinchMode: Sendable {
    
    case accessibilityQuickAction
    
    @available(watchOS 11.0, *)
    case doubleTapGesture
}

extension DoublePinchMode {
    
    public static var automatic: DoublePinchMode {
        if #available(watchOS 11.0, *), DoublePinchMode.isDoubleTapGestureSupported {
            .doubleTapGesture
        } else {
            .accessibilityQuickAction
        }
    }
}

private extension DoublePinchMode {
    
    static var isDoubleTapGestureSupported: Bool { // AKA isSeries9OrNewer
        // https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt
        guard let firstModelDigit = Int(String(describing: model.first)) else {
            return false
        }
        return firstModelDigit >= 7
    }
    
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
