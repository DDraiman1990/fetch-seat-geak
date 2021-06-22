//
//  TrackedEntryCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//


import UIKit

final class TrackedEntryCell: UITableViewCell {
    public static let cellId = "TrackedEntryCell"
    
    private let view: TrackedEntryView = {
        let view = TrackedEntryView(
            title: "",
            subtitle: "",
            price: "",
            imageUrl: nil,
            isTracked: false)
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
    
    func setup(title: String,
               subtitle: String,
               price: String?,
               imageUrl: String?,
               isTracked: Bool) {
        view.set(title: title)
        view.set(subtitle: subtitle)
        view.set(price: price)
        view.set(imageUrl: imageUrl)
        view.set(isTracked: isTracked)
    }
}
