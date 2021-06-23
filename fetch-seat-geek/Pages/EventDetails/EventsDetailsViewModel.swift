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
    private let trackedManager: TrackedManaging
    
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
        self.trackedManager = resolver.resolve()
        
        trackedManager
            .onTrackedChanged
            .subscribeToValue { [weak self] trackedIds in
                self?.valueRelay
                    .mutableValue
                    .headerData?
                    .isTracked = trackedIds.contains(eventId)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        case .viewLoaded:
            fetchEventDetails()
        case .shareTapped:
            presentShare()
        case .trackingTapped:
            trackedManager
                .toggleTracked(id: self.eventId)
                .subscribeToResult { result in
                    switch result {
                    case .success:
                        print("Success")
                    case .failure(let error):
                        print(error)
                    }
                }
                .disposed(by: disposeBag)
        case .travelTimeTapped(_):
            //TODO: Implement if you find the time.
            break
        case .viewAllTapped:
            //TODO: Implement if you find the time.
            break
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
                    //TODO: Show popup and dismiss on approval
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
        downloadEventImage()
            .subscribe { [weak self] image in
                let builder = ShareActivityBuilder(
                    shareData: SeatGeekShareData.event(
                        event: event,
                        image: image))
                let vc = builder.buildActivityViewController { _ in }
                self?.presentRelay.onNext(vc)
            } onFailure: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func downloadEventImage() -> Single<UIImage?> {
        //Nuke should fetch from cache if already downloaded
        return Single.create(subscribe: { [weak self] single in
            guard let url = URL(string: self?.event?.eventImageUrl ?? "") else {
                single(.failure(NSError()))
                return Disposables.create()
            }
            ImagePipeline.shared.loadImage(with: url) { result in
                switch result {
                case .success(let res):
                    single(.success(res.image))
                case .failure(let error):
                    print(error)
                    single(.failure(error))
                }
            }
            return Disposables.create()
        })
    }
    
    private func onFetched(event: SGEvent) {
        self.event = event
        let subtitle = AppConstants
            .DateFormatters
            .fullDateAndTimeFormatter
            .string(from: event.datetimeLocal)
        let isTracked = trackedManager.trackedIds.contains(event.id)
        let headerData = Consumer.HeaderData(
            title: event.title,
            subtitle: subtitle,
            isTracked: isTracked)
        let locationData = Consumer.LocationData(
            locationName: event.venue.name,
            location: event.venue.fullAddress,
            driveTime: "\(Int.random(in: 1...4))h, \(Int.random(in: 1...59)) min",
            walkTime: "\(Int.random(in: 5...40))h, \(Int.random(in: 1...59)) min")
        let data = Consumer.Model(
            headerImageUrl: event.eventImageUrl,
            pageTitle: event.shortTitle,
            headerData: headerData,
            locationData: locationData)
        self.valueRelay.accept(data)
    }
}
