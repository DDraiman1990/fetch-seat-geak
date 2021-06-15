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
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = .red
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        setRoot(viewController: MainTabController(tabs: [
            .init(
                viewController: vc1,
                tabTitle: "VC1",
                tabDeselectedIcon: UIImage(systemName: "bubble.right.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)),
                tabSelectedIcon: UIImage(systemName: "ellipses.bubble.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))),
            .init(
                viewController: vc2,
                tabTitle: "VC2",
                tabDeselectedIcon: UIImage(systemName: "bubble.right.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)),
                tabSelectedIcon: UIImage(systemName: "ellipses.bubble.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))),
            .init(
                viewController: vc3,
                tabTitle: "VC3",
                tabDeselectedIcon: UIImage(systemName: "bubble.right.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)),
                tabSelectedIcon: UIImage(systemName: "ellipses.bubble.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)))
        ]))
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

