//
//  DoublePinchButton.swift
//  DoublePinch
//

import SwiftUI
import WatchKit

struct DoublePinchButton<Label: View>: View {
    
    enum Mode {
        case accessibilityQuickAction
        case doubleTapGesture
    }
    
    let mode: Mode
    
    private let action: () -> Void
    private let label: () -> Label
    
    init(
        mode: Mode = isDoubleTapGestureSupported ? .doubleTapGesture : .accessibilityQuickAction,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.mode = mode
        self.action = action
        self.label = label
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
    
    static var isDoubleTapGestureSupported: Bool { // AKA isSeries9OrNewer
        // https://gist.github.com/adamawolf/3048717#file-apple_mobile_device_types-txt
        guard let firstModelDigit = Int(String(describing: model.first)) else {
            return false
        }
        return firstModelDigit >= 7
    }
    
    var body: some View {
        // handGestureShortcut is watchOS 11 only? Why not 10.0? (release version for Series 9)
        if #available(watchOS 11.0, *) {
            Button(action: action) {
                label()
            }
            .handGestureShortcut(.primaryAction, isEnabled: mode == .doubleTapGesture)
            .accessibilityQuickAction(style: .outline) {
                Button("Accessibility label", action: action)
                    .disabled(mode == .doubleTapGesture)
            }
        } else {
            Button(action: action) {
                label()
            }
            .accessibilityQuickAction(style: .outline) {
                Button("Accessibility label", action: action)
                    .disabled(mode == .doubleTapGesture)
            }
        }
    }
}
