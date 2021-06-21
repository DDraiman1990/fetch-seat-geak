//
//  EventDetailsInformationCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

final class EventDetailsInformationCell: UITableViewCell {
    public static let cellId = "EventDetailsInformationCell"
    
    private let view: EventDetailsInformationView = {
        let view = EventDetailsInformationView(title: "", subtitle: "", isTracked: false)
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
    
    func setup(title: String, subtitle: String, isTracked: Bool) {
        view.set(title: title)
        view.set(subtitle: subtitle)
        view.set(isTracked: isTracked)
    }
}
