//
//  SearchEntryCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

final class SearchEntryCell: UITableViewCell {
    public static let cellId = "SearchEntryCell"
    
    private let view: SearchEntryView = {
        let view = SearchEntryView(title: "", imageUrl: nil)
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
               imageUrl: String?) {
        view.set(title: title)
        view.set(imageUrl: imageUrl)
    }
}
