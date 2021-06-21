//
//  EventsDetailsViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit
import RxSwift
import RxCocoa

final class EventsDetailsViewModel: ViewModel {
    typealias Consumer = EventDetailsViewController
    
    // MARK: - Properties | Dependencies
    
    private let seatGeekInteractor: SeatGeekInteracting
    
    // MARK: - Properties | ViewModel
    
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init())
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<Consumer.Model>> {
        return valueRelay.asObservable().toModelUpdate()
    }
    
    // MARK: - Properties
    private let eventId: Int
    private var event: SGEvent?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(eventId: Int,
         resolver: DependencyResolving) {
        self.eventId = eventId
        self.seatGeekInteractor = resolver.resolve()
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .viewLoaded:
            fetchEventDetails()
        }
    }
    
    // MARK: - Methods | Data Fetching
    
    private func fetchEventDetails() {
        seatGeekInteractor
            .getEvent(id: "\(eventId)")
            .subscribeToResult { [weak self] result in
                switch result {
                case .success(let event):
                    self?.onFetched(event: event)
                case .failure(let error):
                    //TODO: show popup for error
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func onFetched(event: SGEvent) {
        self.event = event
        //TODO: check TrackedManager for isTracked
        let subtitle = AppConstants
            .DateFormatters
            .fullDateAndTimeFormatter
            .string(from: event.datetimeLocal)
        self.valueRelay.accept(.init(
                                headerImageUrl: event.performers.first?.image,
                                pageTitle: event.shortTitle,
                                headerData: .init(
                                    title: event.title,
                                    subtitle: subtitle,
                                    isTracked: false),
                                locationData: .init(
                                    locationName: event.venue.name,
                                    location: event.venue.displayLocation,
                                    driveTime: "\(Int.random(in: 1...4))h, \(Int.random(in: 1...59)) min",
                                    walkTime: "\(Int.random(in: 5...40))h, \(Int.random(in: 1...59)) min")))
    }
}
