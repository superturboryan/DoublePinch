import SwiftUI

extension Button {
    
    public func _performAction() -> Bool {
        if #available(watchOS 11.0, *), let action = getAction((@MainActor () -> Void).self) {
            MainActor.assumeIsolated(action)
            return true
        }
        
        if let action = getAction((() -> Void).self) {
            action()
            return true
        }
        
        return false
    }
    
    private func getAction<T>(_ type: T.Type) -> T? {
        guard let action = Mirror(reflecting: self).descendant("action") else {
            return nil
        }
        
        guard let closure = Mirror(reflecting: action).descendant("closure") else {
            return action as? T
        }
        
        return closure as? T
    }
}
