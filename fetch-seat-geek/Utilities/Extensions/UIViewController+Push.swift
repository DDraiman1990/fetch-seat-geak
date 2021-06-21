//
//  UIViewController+Push.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

extension UIViewController {
    func push(viewController: UIViewController,
              animated: Bool = true) {
        self.navigationController?
            .pushViewController(viewController,
                                animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
}
