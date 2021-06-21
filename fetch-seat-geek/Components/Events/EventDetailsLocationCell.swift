//
//  EventDetailsLocationCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

final class EventDetailsLocationCell: UITableViewCell {
    public static let cellId = "EventDetailsLocationCell"
    
    private let view: EventDetailsLocationView = {
        let view = EventDetailsLocationView(locationName: "", location: "")
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
