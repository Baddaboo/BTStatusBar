//
//  BTLayoutHelper.swift
//  BTStatusBar
//
//  Created by Blake Tsuzaki on 5/28/17.
//  Copyright © 2017 Modoki. All rights reserved.
//

import UIKit

enum BTLayoutPriority {
    case now, eventually, whenever
}

extension UIView {
    var height: CGFloat { return bounds.height }
    var width: CGFloat { return bounds.width }
    var top: CGFloat { return frame.origin.y }
    var bottom: CGFloat { return frame.origin.y + bounds.height }
    var left: CGFloat { return frame.origin.x }
    var right: CGFloat { return frame.origin.x + bounds.width }
    
    func equalHeightWidth(offset: CGFloat = 0) -> NSLayoutConstraint {
        return height(equalTo: self, attribute: .width, offset: offset)
    }
    func height(equalTo height: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
    }
    func height(equalTo view: UIView, attribute: NSLayoutAttribute = .height, offset: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: offset)
    }
    func width(equalTo width: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width)
    }
    func width(equalTo view: UIView, attribute: NSLayoutAttribute = .width, offset: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: offset)
    }
    private func printSuperviewNilError() {
        debugPrint("Warning: superview cannot be nil when creating a constraint constant")
    }
    func top(equalTo top: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview ?? self, attribute: .top, multiplier: 1.0, constant: top)
    }
    func top(equalTo view: UIView, attribute: NSLayoutAttribute = .top, spacing: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: spacing)
    }
    func bottom(equalTo bottom: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview ?? self, attribute: .bottom, multiplier: 1.0, constant: bottom)
    }
    func bottom(equalTo view: UIView, attribute: NSLayoutAttribute = .bottom, spacing: CGFloat = 0, multiplier: CGFloat = 1) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: multiplier, constant: spacing)
    }
    func left(equalTo left: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superview ?? self, attribute: .left, multiplier: 1.0, constant: left)
    }
    func left(equalTo view: UIView, attribute: NSLayoutAttribute = .left, spacing: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: spacing)
    }
    func right(equalTo right: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superview ?? self, attribute: .right, multiplier: 1.0, constant: right)
    }
    func right(equalTo view: UIView, attribute: NSLayoutAttribute = .right, spacing: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: spacing)
    }
    func centerX(offset: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview ?? self, attribute: .centerX, multiplier: 1.0, constant: offset)
    }
    func centerX(equalTo view: UIView, attribute: NSLayoutAttribute = .centerX, spacing: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: spacing)
    }
    func centerY(offset: CGFloat = 0) -> NSLayoutConstraint {
        if superview == nil { printSuperviewNilError() }
        return NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview ?? self, attribute: .centerY, multiplier: 1.0, constant: offset)
    }
    func centerY(equalTo view: UIView, attribute: NSLayoutAttribute = .centerY, spacing: CGFloat = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1.0, constant: spacing)
    }
    
    func replaceConstraint(constraint: inout NSLayoutConstraint?, with newConstraint: NSLayoutConstraint, priority: BTLayoutPriority = .now) {
        if let constraint = constraint {
            constraint.isActive = false
            removeConstraint(constraint)
        }
        newConstraint.isActive = true
        
        switch priority {
        case .now: layoutIfNeeded()
        case .eventually: setNeedsLayout()
        case .whenever: break
        }
        
        constraint = newConstraint
    }
    
    func replaceConstraints(constraints: inout [NSLayoutConstraint]?, with newConstraints: [NSLayoutConstraint], priority: BTLayoutPriority = .now) {
        if let constraints = constraints {
            for constraint in constraints {
                constraint.isActive = false
                removeConstraint(constraint)
            }
        }
        for constraint in newConstraints {
            constraint.isActive = true
        }
        
        switch priority {
        case .now: layoutIfNeeded()
        case .eventually: setNeedsLayout()
        case .whenever: break
        }
        
        constraints = newConstraints
    }
    
    func disableAutoresizingMaskNonsense(views: [UIView]) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func disableAutoresizingMaskNonsense(viewList: [String: UIView]) {
        disableAutoresizingMaskNonsense(views: Array(viewList.values))
    }
    func autoActivateConstraints(viewList: [String: UIView], constraints: [NSLayoutConstraint], priority: BTLayoutPriority = .eventually) {
        autoActivateConstraints(views: Array(viewList.values), constraints: constraints, priority: priority)
    }
    func autoActivateConstraints(viewList: [String: UIView], constraintList: [Any], priority: BTLayoutPriority = .eventually) {
        autoActivateConstraints(views: Array(viewList.values), constraintList: constraintList, priority: priority)
    }
    func autoActivateConstraints(views: [UIView], constraints: [NSLayoutConstraint], priority: BTLayoutPriority = .eventually) {
        disableAutoresizingMaskNonsense(views: views)
        NSLayoutConstraint.activate(constraints)
        
        switch priority {
        case .now: layoutIfNeeded()
        case .eventually: setNeedsLayout()
        case .whenever: break
        }
    }
    func autoActivateConstraints(views: [UIView], constraintList: [Any], priority: BTLayoutPriority = .eventually) {
        var constraints: [NSLayoutConstraint] = []
        for constraint in constraintList {
            if let constraint = constraint as? NSLayoutConstraint {
                constraints.append(constraint)
            } else if let constraintArr = constraint as? [NSLayoutConstraint] {
                for constraint in constraintArr {
                    constraints.append(constraint)
                }
            }
        }
        autoActivateConstraints(views: views, constraints: constraints)
    }
    func compoundConstraints(format: String, views: [String: UIView], metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
        return NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: metrics, views: views)
    }
    
    func addSubviews(_ views: Any) {
        var viewArr = [UIView]()
        
        if let views = views as? [UIView] {
            viewArr = views
        } else if let viewList = views as? [String: UIView] {
            viewArr = Array(viewList.values)
        }
        
        for view in viewArr { addSubview(view) }
    }
}

extension UIViewController {
    func replaceConstraint(constraint: inout NSLayoutConstraint?, with newConstraint: NSLayoutConstraint, priority: BTLayoutPriority = .now) {
        view.replaceConstraint(constraint: &constraint, with: newConstraint, priority: priority)
    }
    func replaceConstraints(constraints: inout [NSLayoutConstraint]?, with newConstraints: [NSLayoutConstraint], priority: BTLayoutPriority = .now) {
        view.replaceConstraints(constraints: &constraints, with: newConstraints, priority: priority)
    }
    func disableAutoresizingMaskNonsense(views: [UIView]) {
        view.disableAutoresizingMaskNonsense(views: views)
    }
    func disableAutoresizingMaskNonsense(viewList: [String: UIView]) {
        view.disableAutoresizingMaskNonsense(viewList: viewList)
    }
    func autoActivateConstraints(viewList: [String: UIView], constraints: [NSLayoutConstraint], priority: BTLayoutPriority = .eventually) {
        view.autoActivateConstraints(viewList: viewList, constraints: constraints, priority: priority)
    }
    func autoActivateConstraints(viewList: [String: UIView], constraintList: [Any], priority: BTLayoutPriority = .eventually) {
        view.autoActivateConstraints(viewList: viewList, constraintList: constraintList, priority: priority)
    }
    func autoActivateConstraints(views: [UIView], constraints: [NSLayoutConstraint], priority: BTLayoutPriority = .eventually) {
        view.autoActivateConstraints(views: views, constraints: constraints, priority: priority)
    }
    func autoActivateConstraints(views: [UIView], constraintList: [Any], priority: BTLayoutPriority = .eventually) {
        view.autoActivateConstraints(views: views, constraintList: constraintList, priority: priority)
    }
    func compoundConstraints(format: String, views: [String: UIView], metrics: [String: Any]? = nil) -> [NSLayoutConstraint] {
        return view.compoundConstraints(format: format, views:views, metrics:metrics)
    }
}
