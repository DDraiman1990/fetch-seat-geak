//
//  PerformerSummaryCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class PerformerSummaryCell: IdentifiableCollectionCell {
    public static let cellId = "PerformerSummaryCell"
    
    private let view: PerformerSummaryView = {
        let view = PerformerSummaryView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(view)
        view.anchor(in: contentView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(performer: SGPerformer) {
        view.setup(performer: performer)
    }
}
