//
//  ViewModel+TypeErasure.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/11/21.
//

import Foundation
import RxSwift
import UIKit

// MARK: - Type Erasure

class _AnyViewModelBase<Consumer: ViewModeled>: ViewModel {
    var value: Consumer.Model {
        return .init()
    }
    
    var valuePublisher: Observable<ModelUpdate<Consumer.Model>> {
        return Observable.empty()
    }
    
    var updatePublisher: Observable<Consumer.Update> {
        return Observable.empty()
    }
    
    var presentPublisher: Observable<UIViewController> {
        return Observable.empty()
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
    
    override var valuePublisher: Observable<ModelUpdate<Consumer.Model>> {
        return wrappedInstance.valuePublisher
    }
    
    override var updatePublisher: Observable<Consumer.Update> {
        return wrappedInstance.updatePublisher
    }
    
    override var presentPublisher: Observable<UIViewController> {
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
    
    var valuePublisher: Observable<ModelUpdate<Consumer.Model>> {
        base.valuePublisher
    }
    
    var updatePublisher: Observable<Consumer.Update> {
        base.updatePublisher
    }
    
    var presentPublisher: Observable<UIViewController> {
        base.presentPublisher
    }
    
    func send(_ interaction: Consumer.Interaction) {
        base.send(interaction)
    }
}
