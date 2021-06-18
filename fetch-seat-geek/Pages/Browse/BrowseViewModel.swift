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
            [.featured],
            [.justForYou],
            [.trendingEvents],
            [.recentlyViewed],
            [.browseCategories],
            [.justAnnounced],
            [.category(named: "Sports")],
            [.category(named: "Concerts")],
            [.category(named: "Broadway Shows")],
            [.category(named: "Comedy")],
            [.category(named: "Music Festivals")]
        ]))
    }
    
    // MARK: - Methods | ViewModel
    
    func send(_ interaction: Consumer.Interaction) {
        switch interaction {
        }
    }
}

