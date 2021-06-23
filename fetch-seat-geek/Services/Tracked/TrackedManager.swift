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
    var onTrackedChanged: Observable<Set<Int>> { get }
    var trackedIds: Set<Int> { get }
    func addToTracked(id: Int) -> Observable<Void>
    func removeFromTracked(id: Int) -> Observable<Void>
    func toggleTracked(id: Int) -> Observable<Bool>
}

final class TrackedManager: TrackedManaging {
    private let trackedDatabaseKey = "tracked-ids"
    private let tracked: BehaviorRelay<Set<Int>> = .init(value: [])
    private let databaseInteractor: DatabaseInteracting
    private let logger: Logger
    
    init(databaseInteractor: DatabaseInteracting,
         logger: Logger) {
        self.databaseInteractor = databaseInteractor
        self.logger = logger
        logger.debug("TrackedManager created.")
        load()
    }
    
    var trackedIds: Set<Int> {
        return tracked.value
    }
    
    var onTrackedChanged: Observable<Set<Int>> {
        return tracked
            .share()
            .asObservable()
            .do(onNext: { [weak self] ids in
                self?.logger.debug("trackeIds changed to \(ids)")
        })
    }
    
    private func load() {
        do {
            let loaded: Set<Int> = try databaseInteractor.get(key: trackedDatabaseKey)
            logger.debug("Successfully loaded tracked ids: \(loaded)")
            self.tracked.accept(loaded)
        } catch {
            if let dbError = error as? DatabaseError,
               dbError != .noValue {
                return
            }
            logger.error(error)
        }
    }
    
    private func store(tracked: Set<Int>) -> Observable<Void>  {
        let key = trackedDatabaseKey
        logger.debug("Attempting to store \(tracked)")
        return Single.create { [weak self] single in
            do {
                try self?.databaseInteractor.store(tracked, forKey: key)
                self?.logger.debug("Successfully stored \(tracked) in key \(key)")
                single(.success(()))
            }
            catch {
                self?.logger.error(error)
                single(.failure(error))
            }
            return Disposables.create()
        }
        .asObservable()
    }
    
    func addToTracked(id: Int) -> Observable<Void> {
        logger.debug("Adding \(id) to tracked.")
        var existing = tracked.value
        existing.insert(id)
        return store(tracked: existing)
            .do(onNext: {
                self.tracked.accept(existing)
            })
    }
    
    func removeFromTracked(id: Int) -> Observable<Void> {
        logger.debug("Removing \(id) from tracked")
        var existing = tracked.value
        existing.remove(id)
        return store(tracked: existing)
            .do(onNext: {
                self.tracked.accept(existing)
            })
    }
    
    func toggleTracked(id: Int) -> Observable<Bool> {
        let isTracked = tracked.value.contains(id)
        logger.debug("\(id) is \(isTracked ? "tracked" : "not tracked")")
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
