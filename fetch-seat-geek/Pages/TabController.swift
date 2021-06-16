//
//  TabController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

class TabController: UITabBarController {
    struct TabbedPage {
        var viewController: UIViewController
        var tabTitle: String? = nil
        var tabDeselectedIcon: UIImage? = nil
        var tabSelectedIcon: UIImage? = nil
    }
    
    struct Style {
        var font: UIFont?
        var tintColor: UIColor?
        var isTranslucent: Bool?
        var barTintColor: UIColor?
        var unselectedItemTintColor: UIColor?
    }
    private let tabs: [TabbedPage]
    private let style: Style

    init(
        tabs: [TabbedPage],
        style: Style = .init()) {
        self.tabs = tabs
        self.style = style
        super.init(nibName: nil, bundle: nil)
        viewControllers = tabs.map {
            $0.viewController.tabBarItem = .init(
                title: $0.tabTitle,
                image: $0.tabDeselectedIcon,
                selectedImage: $0.tabSelectedIcon)
            return $0.viewController
        }
        styleView(by: style)
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func styleView(by style: Style) {
        if let font = style.font {
            let attributes = [NSAttributedString.Key.font: font]
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        }
        if let value = style.tintColor {
            UITabBar.appearance().tintColor = value
        }
        if let value = style.isTranslucent {
            UITabBar.appearance().isTranslucent = value
        }
        if let value = style.barTintColor {
            UITabBar.appearance().barTintColor = value
        }
        if let value = style.unselectedItemTintColor {
            UITabBar.appearance().unselectedItemTintColor = value
        }
    }
    
    private func requestRefresh(fromIndex index: Int) {
        guard tabs.indices ~= index,
              let toRefresh = tabs[index]
                .viewController as? RefreshRequestable else {
            return
        }
        toRefresh.refreshRequested()
    }
}

extension TabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          shouldSelect viewController: UIViewController) -> Bool {
        let newIndex = tabBarController
            .viewControllers?.firstIndex(of: viewController) ?? -1
        if tabBarController.selectedIndex == newIndex {
            requestRefresh(fromIndex: newIndex)
        }
        return true
    }
}

protocol RefreshRequestable: UIViewController {
    func refreshRequested()
}



