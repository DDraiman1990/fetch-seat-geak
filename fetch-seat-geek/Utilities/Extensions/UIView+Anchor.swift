//
//  UIView+Anchor.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import UIKit

extension UIView {
    func embed(
        in parent: UIView,
        padding: CGFloat) {
        anchor(in: parent,
               padding: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding))
    }
    
    func embed(
        in parent: UIView,
        padding: UIEdgeInsets = .zero) {
        anchor(in: parent,
               padding: padding)
    }
    
    func embedInSafeArea(
        of parent: UIView,
        padding: CGFloat = 0) {
        anchorInSafeArea(
            of: parent,
            padding: UIEdgeInsets(
                top: padding,
                left: padding,
                bottom: padding,
                right: padding))
    }
    
    func embedInSafeArea(
        of parent: UIView,
        padding: UIEdgeInsets = .zero) {
        anchorInSafeArea(
            of: parent,
            padding: padding)
    }
    
    func height(
        multiplier: CGFloat,
        relativeTo view: UIView,
        addedOffset: CGFloat = 0,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = self
            .heightAnchor
            .constraint(
                equalTo: view.heightAnchor,
                multiplier: multiplier,
                constant: addedOffset)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func width(
        multiplier: CGFloat,
        relativeTo view: UIView,
        addedOffset: CGFloat = 0,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = self
            .widthAnchor
            .constraint(
                equalTo: view.widthAnchor,
                multiplier: multiplier,
                constant: addedOffset)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchor(
        edge: AnchorType,
        to siblingEdge: AnchorType,
        sibling: UIView,
        padding: CGFloat = 0,
        priority: UILayoutPriority = .required) {
        if let anchor = edge.xLayoutAnchor(for: self),
           let siblingAnchor = siblingEdge.xLayoutAnchor(for: sibling) {
            createXConstraint(
                type: edge,
                priority: priority,
                padding: .init(constant: padding),
                for: anchor,
                otherAnchor: siblingAnchor)
        }
        if let anchor = edge.yLayoutAnchor(for: self),
           let siblingAnchor = siblingEdge.yLayoutAnchor(for: sibling) {
            let priority = min(edge.priority,
                               siblingEdge.priority)
            createYConstraint(
                type: edge,
                priority: priority,
                padding: .init(constant: padding),
                for: anchor,
                otherAnchor: siblingAnchor)
        }
    }
    
    func anchor(
        in parent: UIView,
        to edges: [AnchorType] = [],
        padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if edges.isEmpty {
            bottomAnchor
                .constraint(
                    equalTo: parent.bottomAnchor,
                    constant: -padding.bottom)
                .isActive = true
            topAnchor
                .constraint(
                    equalTo: parent.topAnchor,
                    constant: padding.top)
                .isActive = true
            leadingAnchor
                .constraint(
                    equalTo: parent.leadingAnchor,
                    constant: padding.left)
                .isActive = true
            trailingAnchor
                .constraint(
                    equalTo: parent.trailingAnchor,
                    constant: -padding.right)
                .isActive = true
        } else {
            for edge in edges {
                if let xAnchor = edge.xLayoutAnchor(for: self),
                   let parentXAnchor = edge.xLayoutAnchor(for: parent) {
                    createXConstraint(
                        type: edge,
                        padding: padding,
                        for: xAnchor,
                        otherAnchor: parentXAnchor)
                }
                if let yAnchor = edge.yLayoutAnchor(for: self),
                   let parentYAnchor = edge.yLayoutAnchor(for: parent) {
                    createYConstraint(
                        type: edge,
                        padding: padding,
                        for: yAnchor,
                        otherAnchor: parentYAnchor)
                }
            }
        }
    }
    
    func anchorInSafeArea(
        of parent: UIView,
        to edges: [AnchorType] = [],
        padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if edges.isEmpty {
            bottomAnchor
                .constraint(
                    equalTo: parent.safeAreaLayoutGuide.bottomAnchor,
                    constant: -padding.bottom)
                .isActive = true
            topAnchor
                .constraint(
                    equalTo: parent.safeAreaLayoutGuide.topAnchor,
                    constant: padding.top)
                .isActive = true
            leadingAnchor
                .constraint(
                    equalTo: parent.safeAreaLayoutGuide.leadingAnchor,
                    constant: padding.left)
                .isActive = true
            trailingAnchor
                .constraint(
                    equalTo: parent.safeAreaLayoutGuide.trailingAnchor,
                    constant: -padding.right)
                .isActive = true
        } else {
            for edge in edges {
                if let xAnchor = edge.xLayoutAnchor(for: self),
                   let parentXAnchor = edge.xLayoutAnchor(
                    for: parent,
                    safeArea: true) {
                    createXConstraint(
                        type: edge,
                        padding: padding,
                        for: xAnchor,
                        otherAnchor: parentXAnchor)
                }
                if let yAnchor = edge.yLayoutAnchor(for: self),
                   let parentYAnchor = edge.yLayoutAnchor(
                    for: parent,
                    safeArea: true) {
                    createYConstraint(
                        type: edge,
                        padding: padding,
                        for: yAnchor,
                        otherAnchor: parentYAnchor)
                }
            }
        }
    }
    
    func centerX(
        in parent: UIView,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerXAnchor
            .constraint(equalTo: parent.centerXAnchor)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func centerY(
        in parent: UIView,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = centerYAnchor
            .constraint(equalTo: parent.centerYAnchor)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func center(
        in parent: UIView,
        priority: UILayoutPriority = .required) {
        centerX(
            in: parent,
            priority: priority)
        centerY(
            in: parent,
            priority: priority)
    }
    
    func anchor(
        height: CGFloat,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor
            .constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchor(
        width: CGFloat,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor
            .constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func aspectRatioSquare() {
        aspectRatio(
            widthMultiplier: 1.0,
            priority: .required)
    }
    
    func aspectRatio(
        widthMultiplier: CGFloat,
        priority: UILayoutPriority = .required) {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = self
            .widthAnchor
            .constraint(equalTo: heightAnchor,
                        multiplier: widthMultiplier)
        constraint.priority = priority
        constraint.isActive = true
    }
    
    func anchorYCenteredDynamicHeight(
        in parent: UIView,
        padding: UIEdgeInsets = .zero) {
        anchor(
            in: parent,
            to: [.left(),
                 .right(),
                 .gtTop(priority: .defaultLow),
                 .gtBottom(priority: .defaultLow)],
            padding: padding)
        centerY(in: parent)
    }
    
    func anchorSidesMaxWidth(
        to parent: UIView,
        padding: CGFloat,
        maxWidth: CGFloat,
        safeArea: Bool = false) {
        if safeArea {
            anchorInSafeArea(
                of: parent,
                to: [.left(priority: .init(rawValue: 800)),
                     .right(priority: .init(rawValue: 800))],
                padding: .init(constant: padding))
        } else {
            anchor(
                in: parent,
                to: [.left(priority: .init(rawValue: 800)),
                     .right(priority: .init(rawValue: 800))],
                padding: .init(constant: padding))
        }
        let widthConstraint = widthAnchor
            .constraint(lessThanOrEqualToConstant: maxWidth)
        widthConstraint.priority = .required
        widthConstraint.isActive = true
        centerX(in: parent)
    }
    
    private func createXConstraint(
        type: AnchorType,
        priority: UILayoutPriority? = nil,
        padding: UIEdgeInsets,
        for anchor: NSLayoutXAxisAnchor,
        otherAnchor: NSLayoutXAxisAnchor) {
        let constraint: NSLayoutConstraint
        if type.isGreaterThan {
            constraint = anchor
                .constraint(
                    greaterThanOrEqualTo: otherAnchor,
                    constant: type.padding(from: padding))
        } else if type.isLessThan {
            constraint = anchor
                .constraint(
                    lessThanOrEqualTo: otherAnchor,
                    constant: type.padding(from: padding))
        } else {
            constraint = anchor
                .constraint(
                    equalTo: otherAnchor,
                    constant: type.padding(from: padding))
        }
        constraint.priority = priority ?? type.priority
        constraint.isActive = true
    }
    
    private func createYConstraint(
        type: AnchorType,
        priority: UILayoutPriority? = nil,
        padding: UIEdgeInsets,
        for anchor: NSLayoutYAxisAnchor,
        otherAnchor: NSLayoutYAxisAnchor) {
        let constraint: NSLayoutConstraint
        if type.isGreaterThan {
            constraint = anchor
                .constraint(
                    greaterThanOrEqualTo: otherAnchor,
                    constant: type.padding(from: padding))
        } else if type.isLessThan {
            constraint = anchor
                .constraint(
                    lessThanOrEqualTo: otherAnchor,
                    constant: type.padding(from: padding))
        } else {
            constraint = anchor
                .constraint(
                    equalTo: otherAnchor,
                    constant: type.padding(from: padding))
        }
        constraint.priority = priority ?? type.priority
        constraint.isActive = true
    }
}

enum AnchorType: Equatable {
    static func ==(lhs: AnchorType, rhs: AnchorType) -> Bool {
        switch (lhs, rhs) {
        case (.top, .top),
             (.bottom, .bottom),
             (.left, .left),
             (.right, .right),
             (.ltTop, .ltTop),
             (.ltBottom, .ltBottom),
             (.ltLeft, .ltLeft),
             (.ltRight, .ltRight),
             (.gtTop, .gtTop),
             (.gtBottom, .gtBottom),
             (.gtLeft, .gtLeft),
             (.gtRight, .gtRight):
            return true
        default:
            return false
        }
    }
    
    func xLayoutAnchor(
        for view: UIView,
        safeArea: Bool = false) -> NSLayoutXAxisAnchor? {
        switch self {
        case .left, .gtLeft, .ltLeft:
            return safeArea ?
                view.safeAreaLayoutGuide.leadingAnchor :
                view.leadingAnchor
        case .right, .gtRight, .ltRight:
            return safeArea ?
                view.safeAreaLayoutGuide.trailingAnchor :
                view.trailingAnchor
        default: return nil
        }
    }
    
    func yLayoutAnchor(
        for view: UIView,
        safeArea: Bool = false) -> NSLayoutYAxisAnchor? {
        switch self {
        case .top, .gtTop, .ltTop:
            return safeArea ?
                view.safeAreaLayoutGuide.topAnchor :
                view.topAnchor
        case .bottom, .gtBottom, .ltBottom:
            return safeArea ?
                view.safeAreaLayoutGuide.bottomAnchor :
                view.bottomAnchor
        default: return nil
        }
    }
    
    func padding(from edges: UIEdgeInsets) -> CGFloat {
        switch self {
        case .top, .ltTop, .gtTop:
            return edges.top
        case .bottom, .ltBottom, .gtBottom:
            return -edges.bottom
        case .left, .ltLeft, .gtLeft:
            return edges.left
        case .right, .ltRight, .gtRight:
            return -edges.right
        }
    }
    
    var priority: UILayoutPriority {
        switch self {
        case .top(let priority): return priority
        case .bottom(let priority): return priority
        case .left(let priority): return priority
        case .right(let priority): return priority
        case .ltTop(let priority): return priority
        case .ltBottom(let priority): return priority
        case .ltLeft(let priority): return priority
        case .ltRight(let priority): return priority
        case .gtTop(let priority): return priority
        case .gtBottom(let priority): return priority
        case .gtLeft(let priority): return priority
        case .gtRight(let priority): return priority
        }
    }
    
    var isGreaterThan: Bool {
        switch self {
        case .gtTop, .gtBottom, .gtLeft, .gtRight:
            return true
        default:
            return false
        }
    }
    
    var isLessThan: Bool {
        switch self {
        case .ltTop, .ltBottom, .ltLeft, .ltRight:
            return true
        default:
            return false
        }
    }
    
    case top(priority: UILayoutPriority = .required),
         bottom(priority: UILayoutPriority = .required),
         left(priority: UILayoutPriority = .required),
         right(priority: UILayoutPriority = .required),
         ltTop(priority: UILayoutPriority = .required),
         ltBottom(priority: UILayoutPriority = .required),
         ltLeft(priority: UILayoutPriority = .required),
         ltRight(priority: UILayoutPriority = .required),
         gtTop(priority: UILayoutPriority = .required),
         gtBottom(priority: UILayoutPriority = .required),
         gtLeft(priority: UILayoutPriority = .required),
         gtRight(priority: UILayoutPriority = .required)
}

extension UIEdgeInsets {
    init(constant: CGFloat) {
        self.init(
            top: constant,
            left: constant,
            bottom: constant,
            right: constant)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top: vertical,
            left: horizontal,
            bottom: vertical,
            right: horizontal)
    }
}
