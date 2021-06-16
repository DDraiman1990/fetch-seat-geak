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
        
        let vc1 = UINavigationController(rootViewController: ViewController())
        vc1.view.backgroundColor = .white
        let eventView = EventSummarySmallView(
            event: .init(
                id: 5316859,
                banner: .init(
                    text: "FEATURED",
                    textColor: .white,
                    backgroundColor: UIColor.blue.withAlphaComponent(0.5),
                    font: R.font.proximaNovaSemibold(size: 14) ?? .systemFont(ofSize: 14)),
                title: "Miami Marlins at Chicago Cubs",
                date: Date().addingTimeInterval(24 * 60 * 60 * 2),
                venueName: "Wrigley Field",
                venueLocation: "Chicago, IL",
                ticketPrice: "60+",
                isTracked: false,
                canBeTracked: true,
                imageUrl: "https://seatgeek.com/images/performers-landscape/chicago-cubs-eb9c8c/11/huge.jpg"))
        vc1.view.addSubview(eventView)
        eventView.center(in: vc1.view)
        eventView.anchor(height: 250)
        eventView.anchor(in: vc1.view, to: [.left(), .right()], padding: .init(constant: 16))
        let vc2 = UIViewController()
        vc2.view.backgroundColor = .green
        let vc3 = UIViewController()
        vc3.view.backgroundColor = .blue
        setRoot(viewController: TabController(tabs: [
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

