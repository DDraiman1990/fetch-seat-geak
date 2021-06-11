//
//  ViewModel.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import Combine
import UIKit


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
    var valuePublisher: AnyPublisher<ModelUpdate<Consumer.Model>, Never> { get }
    var updatePublisher: AnyPublisher<Consumer.Update, Never> { get }
    var presentPublisher: AnyPublisher<UIViewController, Never> { get }
    func send(_ interaction: Consumer.Interaction)
}

// MARK: - Default Implementations

extension ViewModel {
    var updatePublisher: AnyPublisher<Consumer.Update, Never> {
        return Future<Consumer.Update, Never>({ _ in }).eraseToAnyPublisher()
    }
    var presentPublisher: AnyPublisher<UIViewController, Never> {
        return Just(UIViewController()).eraseToAnyPublisher()
    }
    func eraseToAnyViewModel() -> AnyViewModel<Consumer> {
        return AnyViewModel<Consumer>(self)
    }
}
