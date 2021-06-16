//
//  ViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import UIKit
import RxSwift


/// Responsible for receiving interactions from a ViewModeled consumer
/// and update the model, expected by said ViewModeled.
///
/// If the ViewModel has one-off updates required you can simply provide a
/// value to `updatePublisher()`.
///
/// If the ViewModel wants the ViewModeled to present other ViewControllers, you
/// can simply provide a value to `presentPublisher()`.
///
/// Use `send(_ interaction:)` to send interactions to the ViewModel
protocol ViewModel {
    associatedtype Consumer: ViewModeled
    var value: Consumer.Model { get }
    var valuePublisher: Observable<ModelUpdate<Consumer.Model>> { get }
    var updatePublisher: Observable<Consumer.Update> { get }
    var presentPublisher: Observable<UIViewController> { get }
    func send(_ interaction: Consumer.Interaction)
}

// MARK: - Default Implementations

extension ViewModel {
    var updatePublisher: Observable<Consumer.Update> {
        return Observable.empty()
    }
    var presentPublisher: Observable<UIViewController> {
        return Observable.empty()
    }
    func eraseToAnyViewModel() -> AnyViewModel<Consumer> {
        return AnyViewModel<Consumer>(self)
    }
}
