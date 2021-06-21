//
//  FeaturedInnerCollectionCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class FeaturedInnerCollectionCell: UITableViewCell {
    public static let cellId = "FeaturedInnerCollectionCell"
    
    private let view: FeaturedInnerCollectionView = {
        let view = FeaturedInnerCollectionView()
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
    
    func setup(data: [FeaturedInnerCollectionView.FeaturedData]) {
        view.set(data: data)
    }
}
