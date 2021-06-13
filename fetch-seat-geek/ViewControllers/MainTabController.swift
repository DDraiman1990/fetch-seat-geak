//
//  MainTabController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/12/21.
//

import UIKit
import Combine

final class StamViewController: UIViewController {
    private let networkService: NetworkServicing
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("TEST", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(onTestTapped), for: .touchUpInside)
        return button
    }()
    
    init(resolver: DependencyResolving) {
        self.networkService = resolver.resolve()
        super.init(nibName: nil, bundle: nil)
        view.addSubview(testButton)
        testButton.center(in: view)
        testButton.anchor(height: 44)
        testButton.anchor(width: 300)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTestTapped() {
        networkService
            .makeRequest(route: SeatGeekRoutes.EventsRequest.all)
            .sinkToResult { result in
                switch result {
                case .success(let networkResult):
                    print(networkResult.response?.statusCode ?? -1)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            .store(in: &subscriptions)
    }
}
