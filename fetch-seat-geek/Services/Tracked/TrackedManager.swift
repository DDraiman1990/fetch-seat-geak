//
//  TrackedManager.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import Foundation
import RxSwift
import RxCocoa

protocol TrackedManaging {
    var trackedIds: Observable<Set<Int>> { get }
    
    func addToTracked(id: Int) -> Observable<Void>
    func removeFromTracked(id: Int) -> Observable<Void>
    func toggleTracked(id: Int) -> Observable<Bool>
}

final class TrackedManager: TrackedManaging {
    private let trackedDatabaseKey = "tracked-ids"
    private let tracked: BehaviorRelay<Set<Int>> = .init(value: [])
    private let databaseInteractor: DatabaseInteracting
    
    init(databaseInteractor: DatabaseInteracting) {
        self.databaseInteractor = databaseInteractor
        load()
    }
    
    var trackedIds: Observable<Set<Int>> {
        return tracked.share().asObservable()
    }
    
    private func load() {
        do {
            let loaded: Set<Int> = try databaseInteractor.get(key: trackedDatabaseKey)
            self.tracked.accept(loaded)
        } catch {
            if let dbError = error as? DatabaseError,
               dbError != .noValue {
                return
            }
            //TODO: log
            print(error)
        }
    }
    
    private func store(tracked: Set<Int>) -> Observable<Void>  {
        let key = trackedDatabaseKey
        return Single.create { [weak self] single in
            do {
                try self?.databaseInteractor.store(tracked, forKey: key)
                single(.success(()))
            }
            catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
        .asObservable()
    }
    
    func addToTracked(id: Int) -> Observable<Void> {
        var existing = tracked.value
        existing.insert(id)
        return store(tracked: existing)
            .do(onNext: {
                self.tracked.accept(existing)
            })
    }
    
    func removeFromTracked(id: Int) -> Observable<Void> {
        var existing = tracked.value
        existing.remove(id)
        return store(tracked: existing)
            .do(onNext: {
                self.tracked.accept(existing)
            })
    }
    
    func toggleTracked(id: Int) -> Observable<Bool> {
        let isTracked = tracked.value.contains(id)
        if isTracked {
            return removeFromTracked(id: id)
                .map { !isTracked }
        }
        else {
            return addToTracked(id: id)
                .map { !isTracked }
        }
    }
}

protocol TrackableView: UIView {
    var trackTapped: ((Int) -> Void)? { get set }
}
