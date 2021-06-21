//
//  ApplicationManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class ApplicationManager {
    private let dependencyManager: DependencyManaging = DependencyManager()
    weak var windowManager: WindowManaging?
    
    init(windowManager: WindowManaging?) {
        self.windowManager = windowManager
    }
    
    func presentRequiredPage() {
        let vm = BrowseViewModel(resolver: DependencyResolver.shared)
        let vc = BrowseViewController(viewModel: vm.eraseToAnyViewModel())
        let nc = UINavigationController(rootViewController: vc)
        windowManager?.setRoot(viewController: nc)
    }
}
