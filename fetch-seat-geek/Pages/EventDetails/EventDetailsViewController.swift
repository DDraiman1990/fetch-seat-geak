//
//  EventDetailsViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//


import UIKit
import RxSwift

final class EventDetailsViewController: UIViewController, ViewModeled {
    // MARK: - Properties | ViewModel
    
    struct Model: DataModel {
        
    }
    
    enum Interaction {
        case viewLoaded
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: AnyViewModel<EventDetailsViewController>
    
    // MARK: - Lifecycle
    
    init(viewModel: AnyViewModel<EventDetailsViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        bindViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setup
    
    private func bindViewModel() {
        viewModel
            .valuePublisher
            .observe(on: MainScheduler.instance)
            .subscribeToValue { [weak self] model in
                self?.onModelChanged(model: model.newValue)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func onModelChanged(model: Model) {
        
    }
}
