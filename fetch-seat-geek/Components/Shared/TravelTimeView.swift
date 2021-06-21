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
        return imageView
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(timeLabel)
        return stack
    }()
    
    init(title: String,
         travelTime: String,
         icon: UIImage?) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self, padding: .init(constant: 14))
        addSubview(iconImageView)
        iconImageView.anchor(
            in: self,
            to: [.top(), .bottom(), .right()],
            padding: .init(top: -16, left: 0, bottom: -12, right: -12))
        set(title: title)
        set(travelTime: travelTime)
        set(icon: icon)
        layer.cornerRadius = 8
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 6
        layer.shadowOffset = .init(width: 0, height: 3)
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
