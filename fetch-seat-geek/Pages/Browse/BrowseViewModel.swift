//
//  BrowseViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit
import RxSwift
import RxCocoa

final class BrowseViewModel: ViewModel {
    typealias Consumer = BrowseViewController
        
    // MARK: - Properties | ViewModel
    
    private let valueRelay: BehaviorRelay<Consumer.Model> = .init(value: .init())
    
    var value: Consumer.Model {
        return valueRelay.value
    }
    
    var valuePublisher: Observable<ModelUpdate<BrowseViewController.Model>> {
        return valueRelay.asObservable().toModelUpdate()
    }
    
    // MARK: - Lifecycle
    
    init() {
        valueRelay.accept(.init(sections: [
            .init(header: nil, data: .featured, separator: false),
            .init(header: Consumer.Row.justForYou.title, data: .justForYou),
            .init(header: Consumer.Row.trendingEvents.title, data: .trendingEvents),
            .init(header: Consumer.Row.recentlyViewed.title, data: .recentlyViewed),
            .init(header: Consumer.Row.browseCategories.title, data: .browseCategories),
            .init(header: Consumer.Row.justAnnounced.title, data: .justAnnounced),
            .init(header: "Sports", data: .category(named: "Sports")),
            .init(header: "Concerts", data: .category(named: "Concerts")),
            .init(header: "Broadway Shows", data: .category(named: "Broadway Shows")),
            .init(header: "Comedy", data: .category(named: "Comedy")),
            .init(header: "Music Festivals", data: .category(named: "Music Festivals"))
        ]))
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        }
    }
}

