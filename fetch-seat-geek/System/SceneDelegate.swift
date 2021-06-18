//
//  SceneDelegate.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/10/21.
//

/*In case we want to migrate the project to iOS 13+*/

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, WindowManaging {
    var window : UIWindow?
    func scene(_ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else {
            fatalError("Unexpected scene type")
        }
        self.window = UIWindow(windowScene: scene)
        let vc = UIViewController()
        vc.view.backgroundColor = .blue
        setRoot(viewController: TestViewController())
    }
}

