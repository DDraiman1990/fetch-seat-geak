//
//  EventsDetailsViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke

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
    
    private let presentRelay: PublishSubject<UIViewController> = .init()
    var presentPublisher: Observable<UIViewController> {
        return presentRelay.share().asObservable()
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
        case .shareTapped:
            presentShare()
        case .trackingTapped:
            //TODO: tracking logic
            print("TRACKING")
        case .travelTimeTapped(method: let method):
            //TODO: implement simple popup
            print("Travel TIme")
        case .viewAllTapped:
            //TODO: show list of all
            print("View ALl")
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
    
    private func presentShare() {
        guard let event = self.event else {
            return
        }
        let builder = ShareActivityBuilder(
            shareData: SeatGeekShareData.event(
                event: event,
                image: self.value.headerImage))
        let vc = builder.buildActivityViewController { _ in }
        presentRelay.onNext(vc)
    }
    
    private func onFetched(event: SGEvent) {
        self.event = event
        if let url = URL(string: event.performers.first?.image ?? "") {
            ImagePipeline.shared.loadImage(with: url) { [weak self] result in
                switch result {
                case .success(let res):
                    DispatchQueue.main.async {
                        self?.valueRelay.mutableValue.headerImage = res.image
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        let subtitle = AppConstants
            .DateFormatters
            .fullDateAndTimeFormatter
            .string(from: event.datetimeLocal)
        self.valueRelay.accept(.init(
                                headerImage: nil,
                                pageTitle: event.shortTitle,
                                headerData: .init(
                                    title: event.title,
                                    subtitle: subtitle,
                                    isTracked: false),
                                locationData: .init(
                                    locationName: event.venue.name,
                                    location: event.venue.fullAddress,
                                    driveTime: "\(Int.random(in: 1...4))h, \(Int.random(in: 1...59)) min",
                                    walkTime: "\(Int.random(in: 5...40))h, \(Int.random(in: 1...59)) min")))
    }
}
