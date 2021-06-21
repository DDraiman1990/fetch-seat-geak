//
//  EventsInnerCollectionCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class EventsInnerCollectionCell: UITableViewCell, CollectionViewContaining, TrackableView {
    public static let cellId = "EventsInnerCollectionCell"
    
    var onSelectedItem: ((IndexPath) -> Void)? {
        get {
            view.onSelectedItem
        }
        set {
            view.onSelectedItem = newValue
        }
    }
    
    var trackTapped: ((Int) -> Void)? {
        get {
            view.trackTapped
        }
        set {
            view.trackTapped = newValue
        }
    }
    
    private let view: EventsCollectionView = {
        let view = EventsCollectionView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.anchor(in: contentView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(data: [SGEventSummary]) {
        view.set(data: data)
    }
    
    func set(trackdIds: Set<Int>) {
        view.set(trackedIds: trackdIds)
    }
}
