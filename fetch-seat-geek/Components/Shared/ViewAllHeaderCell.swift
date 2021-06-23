//
//  ViewAllHeaderCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/22/21.
//

import UIKit

final class ViewAllHeaderCell: UITableViewCell {
    public static let cellId = "ViewAllHeaderCell"
    
    // MARK: - Properties
    
    var onActionTapped: (() -> Void)? {
        get {
            view.onActionTapped
        }
        set {
            view.onActionTapped = newValue
        }
    }
    
    // MARK: - UI Components
    
    private let view: ViewMoreHeaderView = ViewMoreHeaderView(
        title: "",
        actionTitle: "View All")
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.anchor(in: contentView)
        selectionStyle = .none
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setters
    
    func setup(title: String) {
        view.set(title: title)
    }
}
