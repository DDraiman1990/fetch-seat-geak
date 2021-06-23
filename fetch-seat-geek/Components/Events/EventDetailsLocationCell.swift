//
//  EventDetailsLocationCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

final class EventDetailsLocationCell: UITableViewCell {
    public static let cellId = "EventDetailsLocationCell"
    
    // MARK: - Properties
    
    var onViewAllTapped: (() -> Void)? {
        get {
            view.onViewAllTapped
        }
        set {
            view.onViewAllTapped = newValue
        }
    }
    var onTravelTimeTapped: ((TravelTime) -> Void)? {
        get {
            view.onTravelTimeTapped
        }
        set {
            view.onTravelTimeTapped = newValue
        }
    }
    
    // MARK: - UI Components
    
    private let view: EventDetailsLocationView = {
        let view = EventDetailsLocationView(locationName: "", location: "")
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.anchor(in: contentView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setters
    
    func setup(locationName: String,
               location: String,
               driveTime: String?,
               walkTime: String?) {
        view.set(location: location)
        view.set(locationName: locationName)
        view.set(driveTime: driveTime)
        view.set(walkTime: walkTime)
    }
}
