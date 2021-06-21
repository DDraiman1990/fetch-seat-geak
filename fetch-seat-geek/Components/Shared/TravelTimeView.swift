//
//  TravelTimeView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class TravelTimeView: UIView {
    var onTapped: (() -> Void)?
    private let gestureRecognizer: UITapGestureRecognizer = .init()
    private let titleLabel = UILabel().styled(with: .travelTimeTitle)
    private let timeLabel = UILabel().styled(with: .travelTimeTime)
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.alpha = 0.3
        return imageView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fill
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(timeLabel)
        return stack
    }()
    
    private lazy var wrapper: UIView = {
        let view = UIView()
        view.addSubview(contentStack)
        contentStack.centerY(in: view)
        contentStack.anchor(
            in: view,
            to: [.left(), .right(), .gtTop(), .gtBottom()],
            padding: .init(constant: 14))
        view.addSubview(iconImageView)
        view.clipsToBounds = true
        iconImageView.width(multiplier: 0.8, relativeTo: view)
        iconImageView.height(multiplier: 1.0, relativeTo: view)
        iconImageView
            .centerYAnchor
            .constraint(equalTo: view.centerYAnchor,
                        constant: 16)
            .isActive = true
        iconImageView
            .centerXAnchor
            .constraint(equalTo: view.trailingAnchor,
                        constant: -16)
            .isActive = true
        return view
    }()
    
    init(title: String,
         travelTime: String,
         icon: UIImage?) {
        super.init(frame: .zero)
        addSubview(wrapper)
        wrapper.anchor(in: self)
        set(title: title)
        set(travelTime: travelTime)
        set(icon: icon)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 2
        layer.shadowOffset = .init(width: 0, height: 0)
        addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.addTarget(self, action: #selector(tapped))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapped() {
        onTapped?()
    }
    
    func set(icon: UIImage?) {
        iconImageView.image = icon
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(travelTime: String) {
        timeLabel.text = travelTime
    }
}
