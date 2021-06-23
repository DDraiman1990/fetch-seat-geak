//
//  SeeMoreView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class SeeMoreView: UIView {
    
    // MARK: - Properties
    
    var onTapped: (() -> Void)?
    private let gestureRecognizer = UITapGestureRecognizer()

    // MARK: - UI Components
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 8
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(chevronImageView)
        return stack
    }()
    
    private let titleLabel = UILabel().styled(with: .seeMoreTitle)
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.chevronRight()
        imageView.tintColor = UIColor.black.withAlphaComponent(0.6)
        imageView.contentMode = .scaleAspectFit
        imageView.anchor(width: 26)
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    init(title: String) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self, padding: .init(horizontal: 12, vertical: 6))
        set(title: title)
        gestureRecognizer.addTarget(self, action: #selector(tapped))
        addGestureRecognizer(gestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setters
    
    func set(title: String) {
        titleLabel.text = R.string.main.view_all_in(title)
    }
    
    // MARK: - Methods | Actions
    
    @objc private func tapped() {
        onTapped?()
    }
}
