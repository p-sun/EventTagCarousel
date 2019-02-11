//
//  Constraints+Activation+Priority.swift
//  FunHubUnitTests
//
//  Created by Paige Sun on 11/12/18.
//

import UIKit

public extension Sequence where Element == NSLayoutConstraint {
    
    public func activate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.activate(constraints)
        }
    }
    
    public func deActivate() {
        if let constraints = self as? [NSLayoutConstraint] {
            NSLayoutConstraint.deactivate(constraints)
        }
    }
}

public extension NSLayoutConstraint {
    
    public func with(_ p: UILayoutPriority) -> Self {
        priority = p
        return self
    }
    
    public func set(active: Bool) -> Self {
        isActive = active
        return self
    }
}

public extension UIView {
    
    public func setHugging(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(priority, for: axis)
    }
    
    public func setCompressionResistance(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        setContentCompressionResistancePriority(priority, for: axis)
    }
}
