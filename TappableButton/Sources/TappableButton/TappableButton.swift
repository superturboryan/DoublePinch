import SwiftUI

extension Button {
    
    public var _action: (@MainActor () -> Void)? {
        guard let action = Mirror(reflecting: self).descendant("action") else {
            return nil
        }
        
        guard let closure = Mirror(reflecting: action).descendant("closure") else {
            return nil
        }
        
        return closure as? (@MainActor () -> Void)
    }
}
