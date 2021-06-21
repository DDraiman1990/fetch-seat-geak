//
//  WindowManaging.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

protocol WindowManaging: class {
    var window: UIWindow? { get set }
}

extension WindowManaging {
    func setRoot(
        viewController: UIViewController,
        animated: Bool = false) {
        guard let window = window else {
            return
        }
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        if animated {
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {},
                              completion: nil)
        }
    }
}
