//
//  EventSummaryLargeCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class EventSummaryLargeCell: UICollectionViewCell {
    public static let cellId = "EventSummaryLargeCell"
    
    // MARK: - Properties
    
    var trackTapped: (() -> Void)? {
        get {
            view.trackTapped
        }
        set {
            view.trackTapped = newValue
        }
    }
    
    // MARK: - UI Components
    
    private let view: EventSummaryLargeView = {
        let view = EventSummaryLargeView()
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(view)
        view.anchor(in: contentView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setters
    
    func setup(event: SGEventSummary) {
        view.setup(using: event)
    }
    
    func set(isTracked: Bool) {
        view.set(isTracked: isTracked)
    }
}
