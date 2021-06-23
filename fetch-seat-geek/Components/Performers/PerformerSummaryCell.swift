//
//  PerformerSummaryCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class PerformerSummaryCell: UICollectionViewCell {
    public static let cellId = "PerformerSummaryCell"
    
    // MARK: - UI Components
    
    private let view: PerformerSummaryView = {
        let view = PerformerSummaryView()
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
    
    func setup(performer: SGPerformerSummary) {
        view.setup(performer: performer)
    }
}
