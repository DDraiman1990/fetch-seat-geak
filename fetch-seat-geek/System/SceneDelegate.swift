//
//  SceneDelegate.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            fatalError("Unexpected scene type")
        }
        self.window = UIWindow(windowScene: scene)
        setRoot(viewController: UIViewController())
    }
    
    private func setRoot(
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
