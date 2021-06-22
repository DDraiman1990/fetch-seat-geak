//
//  PageFactory.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

enum PageFactory {
    static func searchPage() -> UIViewController {
        let vm = SearchViewModel(resolver: DependencyResolver.shared)
        let vc = SearchViewController(viewModel: vm.eraseToAnyViewModel())
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    static func eventsDetails(eventId: Int) -> UIViewController {
        let vm = EventsDetailsViewModel(
            eventId: eventId,
            resolver: DependencyResolver.shared)
        let vc = EventDetailsViewController(viewModel: vm.eraseToAnyViewModel())
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func trackedEvents() -> UIViewController {
        let vm = TrackedViewModel(resolver: DependencyResolver.shared)
        let vc = TrackedViewController(viewModel: vm.eraseToAnyViewModel())
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func browsePage() -> UIViewController {
        let vm = BrowseViewModel(resolver: DependencyResolver.shared)
        let vc = BrowseViewController(viewModel: vm.eraseToAnyViewModel())
        let nc = UINavigationController(rootViewController: vc)
        return nc
    }
    
    static func tabController() -> UIViewController {
        return TabController(
            tabs: [
                .init(viewController: browsePage(),
                      tabTitle: R.string.main.tab_browse_title(),
                      tabDeselectedIcon: R.image.globe()),
                .init(viewController: searchPage(),
                      tabTitle: R.string.main.tab_search_title(),
                      tabDeselectedIcon: R.image.magnifyingglass()),
                .init(viewController: trackedEvents(),
                      tabTitle: R.string.main.tab_tracking_title(),
                      tabDeselectedIcon: R.image.heart())
            ],
            style: .init(
                font: R.font.proximaNovaSemibold(size: 10),
                tintColor: R.color.seatGeekBlue(),
                isTranslucent: false,
                unselectedItemTintColor: UIColor.black.withAlphaComponent(0.7)))
    }
}
