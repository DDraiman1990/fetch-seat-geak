//
//  ActionButton.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class ActionButton: UIView {
    private let gestureRecognizer: UITapGestureRecognizer = .init()
    private let titleLabel = UILabel().styled(with: .actionButton)
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.addArrangedSubview(iconImageView)
        stack.addArrangedSubview(titleLabel)
        return stack
    }()
    
    init(title: String,
         icon: UIImage?,
         backgroundColor: UIColor) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(horizontal: 16, vertical: 6))
        set(title: title)
        set(icon: icon)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 8
        addGestureRecognizer(gestureRecognizer)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(_ target: Any, action: Selector) {
        gestureRecognizer.addTarget(target, action: action)
    }
    
    func set(icon: UIImage?) {
        iconImageView.image = icon
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
}
