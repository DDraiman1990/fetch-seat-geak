//
//  GenresInnerCollectionCell.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class GenresInnerCollectionCell: UITableViewCell, CollectionViewContaining {
    public static let cellId = "GenresInnerCollectionCell"
    
    // MARK: - Properties
    
    var onSelectedItem: ((IndexPath) -> Void)? {
        get {
            view.onSelectedItem
        }
        set {
            view.onSelectedItem = newValue
        }
    }
    
    // MARK: - UI Components
    
    private let view: GenresCollectionView = {
        let view = GenresCollectionView()
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
    
    func setup(data: [SGGenre]) {
        view.set(data: data)
    }
}
