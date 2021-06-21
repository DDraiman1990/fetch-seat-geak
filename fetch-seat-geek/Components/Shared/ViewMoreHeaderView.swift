//
//  ViewMoreHeaderView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class ViewMoreHeaderView: UIView {
    var onActionTapped: (() -> Void)?
    private let actionGestureRecognizer = UITapGestureRecognizer()
    private let titleLabel = UILabel().styled(with: .viewMoreHeaderTitle)
    private let actionLabel = UILabel().styled(with: .viewMoreHeaderAction)
    private lazy var actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = actionLabel.textColor
        imageView.image = R.image.chevronRight()
        imageView.anchor(width: 16)
        return imageView
    }()
    
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.addArrangedSubview(actionLabel)
        stack.addArrangedSubview(actionImageView)
        stack.anchor(height: 16)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(actionStack)
        return stack
    }()
    
    init(title: String, actionTitle: String) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(horizontal: 14, vertical: 8))
        set(title: title)
        set(actionTitle: actionTitle)
        actionGestureRecognizer.addTarget(self, action: #selector(actionTapped))
        actionStack.addGestureRecognizer(actionGestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(actionTitle: String) {
        actionLabel.text = actionTitle
    }
    
    @objc private func actionTapped() {
        onActionTapped?()
    }
}
