//
//  TestViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/13/21.
//

import UIKit
import Combine

final class TestViewController: UIViewController {
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("Event", for: .normal)
        button.addTarget(self, action: #selector(onEventTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var allEventsButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("All Events", for: .normal)
        button.addTarget(self, action: #selector(onAllEventsTapped), for: .touchUpInside)
        return button
    }()
    private lazy var performerButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("Performer", for: .normal)
        button.addTarget(self, action: #selector(onPerformerTapped), for: .touchUpInside)
        return button
    }()
    private lazy var allPerformersButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("All Performers", for: .normal)
        button.addTarget(self, action: #selector(onAllPerformerTapped), for: .touchUpInside)
        return button
    }()
    private lazy var venueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("Venue", for: .normal)
        button.addTarget(self, action: #selector(onVenueTapped), for: .touchUpInside)
        return button
    }()
    private lazy var allVenuesButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = .red
        button.setTitle("All Venues", for: .normal)
        button.addTarget(self, action: #selector(onAllVenuesTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.spacing = 8
        stack.addArrangedSubview(eventButton)
        stack.addArrangedSubview(allEventsButton)
        stack.addArrangedSubview(performerButton)
        stack.addArrangedSubview(allPerformersButton)
        stack.addArrangedSubview(venueButton)
        stack.addArrangedSubview(allVenuesButton)
        return stack
    }()
    
    private let seatGeekInteractor: SeatGeekInteracting
    
    init(resolver: DependencyResolving) {
        self.seatGeekInteractor = resolver.resolve()
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(contentStack)
        contentStack.anchorInSafeArea(of: view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onEventTapped() {
        seatGeekInteractor
            .getEvent(id: "5203641")
            .sinkToResult { result in
                switch result {
                case .success(let event):
                    print(event)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    
    var allEventsPage: Int = 0
    var allPerformersPage: Int = 0
    var allVenuesPage: Int = 0
    
    @objc private func onAllEventsTapped() {
        seatGeekInteractor
            .getAllEvents(page: allEventsPage, perPage: 3)
            .sinkToResult { result in
                switch result {
                case .success(let response):
                    self.allEventsPage += 1
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    @objc private func onPerformerTapped() {
        seatGeekInteractor
            .getPerformer(id: "11591")
            .sinkToResult { result in
                switch result {
                case .success(let event):
                    print(event)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    @objc private func onAllPerformerTapped() {
        seatGeekInteractor
            .getAllPerformers(page: allPerformersPage, perPage: 3)
            .sinkToResult { result in
                switch result {
                case .success(let response):
                    self.allPerformersPage += 1
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    @objc private func onVenueTapped() {
        seatGeekInteractor
            .getVenue(id: "35")
            .sinkToResult { result in
                switch result {
                case .success(let venue):
                    print(venue)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
    @objc private func onAllVenuesTapped() {
        seatGeekInteractor
            .getAllVenues(page: allVenuesPage, perPage: 3)
            .sinkToResult { result in
                switch result {
                case .success(let response):
                    self.allVenuesPage += 1
                    print(response)
                case .failure(let error):
                    print(error)
                }
            }
            .store(in: &subscriptions)
    }
}
