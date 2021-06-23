//
//  SearchEntryView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit
import Nuke

final class SearchEntryView: UIView {
    
    // MARK: - UI Components
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.addArrangedSubview(entryImageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(chevronImageView)
        return stack
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.chevronRight()
        imageView.tintColor = UIColor.black.withAlphaComponent(0.3)
        imageView.anchor(width: 16)
        return imageView
    }()
    
    private lazy var entryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = UILabel().styled(with: .searchEntryTitle)
    
    // MARK: - Lifecycle
    
    init(title: String,
         imageUrl: String?) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self,
                            padding: .init(horizontal: 18, vertical: 10))
        entryImageView.width(multiplier: 0.2, relativeTo: self)

        set(title: title)
        set(imageUrl: imageUrl)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        entryImageView.clipsToBounds = false
        entryImageView.layer.cornerRadius = entryImageView.frame.height
    }
    
    // MARK: - Methods | Setters
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(imageUrl: String?) {
        if let path = imageUrl,
           let url = URL(string: path) {
            Nuke.loadImage(with: url, into: entryImageView)
        }
    }
}
