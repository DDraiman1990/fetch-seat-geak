//
//  GenreSummaryCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class GenreSummaryCell: IdentifiableCollectionCell {
    public static let cellId = "GenreSummaryCell"
    
    private let view: GenreSummaryView = {
        let view = GenreSummaryView()
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
    
    func setup(genre: SGGenre) {
        view.setup(genre: genre)
    }
}
