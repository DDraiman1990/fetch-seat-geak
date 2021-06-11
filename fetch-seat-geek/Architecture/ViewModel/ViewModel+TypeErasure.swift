//
//  ViewModel+TypeErasure.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import Combine
import UIKit

// MARK: - Type Erasure

class _AnyViewModelBase<Consumer: ViewModeled>: ViewModel {
    var value: Consumer.Model {
        return .init()
    }
    
    var valuePublisher: AnyPublisher<ModelUpdate<Consumer.Model>, Never> {
        return Just(ModelUpdate(oldValue: nil, newValue: .init())).eraseToAnyPublisher()
    }
    
    var updatePublisher: AnyPublisher<Consumer.Update, Never> {
        return Future<Consumer.Update, Never>({ _ in }).eraseToAnyPublisher()
    }
    
    var presentPublisher: AnyPublisher<UIViewController, Never> {
        return Just(UIViewController()).eraseToAnyPublisher()
    }
    
    func send(_ interaction: Consumer.Interaction) {
        
    }
    
    @available(*, unavailable)
    init() {}
}

class _AnyViewModelWrapper<VM: ViewModel>: _AnyViewModelBase<VM.Consumer> {

    private let wrappedInstance: VM

    init(_ vm: VM) {
        wrappedInstance = vm
    }
    
    override var value: Consumer.Model {
        return wrappedInstance.value
    }
    
    override var valuePublisher: AnyPublisher<ModelUpdate<Consumer.Model>, Never> {
        return wrappedInstance.valuePublisher
    }
    
    override var updatePublisher: AnyPublisher<Consumer.Update, Never> {
        return wrappedInstance.updatePublisher
    }
    
    override var presentPublisher: AnyPublisher<UIViewController, Never> {
        return wrappedInstance.presentPublisher
    }
    
    override func send(_ interaction: Consumer.Interaction) {
        wrappedInstance.send(interaction)
    }
}

/// A ViewModeled coupled with the given Consumer.
final class AnyViewModel<Consumer: ViewModeled>: ViewModel {
    private let base: _AnyViewModelBase<Consumer>

    init<ImplementingType: ViewModel>(_ viewModel: ImplementingType)
    where ImplementingType.Consumer == Consumer {
        base = _AnyViewModelWrapper(viewModel)
    }

    var value: Consumer.Model {
        base.value
    }
    
    var valuePublisher: AnyPublisher<ModelUpdate<Consumer.Model>, Never> {
        base.valuePublisher
    }
    
    var updatePublisher: AnyPublisher<Consumer.Update, Never> {
        base.updatePublisher
    }
    
    var presentPublisher: AnyPublisher<UIViewController, Never> {
        base.presentPublisher
    }
    
    func send(_ interaction: Consumer.Interaction) {
        base.send(interaction)
    }
}
