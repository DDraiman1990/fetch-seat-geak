//
//  TrackedEntryView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit
import Nuke

final class TrackedEntryView: UIView {
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(textsStack)
        stack.addArrangedSubview(heartButton)
        return stack
    }()
    
    private lazy var textsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 2
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.addArrangedSubview(priceLabel)
        return stack
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let heartButton = HeartButton(isActive: false)
    private let titleLabel = UILabel().styled(with: .trackedEventTitle)
    private let subtitleLabel = UILabel().styled(with: .trackedEventSubtitle)
    private let priceLabel = UILabel().styled(with: .trackedEventPrice)
    
    init(title: String,
         subtitle: String,
         price: String?,
         imageUrl: String?,
         isTracked: Bool) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self,
                            padding: .init(constant: 14))
        
        imageView.width(multiplier: 0.2, relativeTo: self)
        heartButton.width(multiplier: 0.1, relativeTo: self)
        set(title: title)
        set(subtitle: subtitle)
        set(price: price)
        set(imageUrl: imageUrl)
        set(isTracked: isTracked)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    func set(subtitle: String) {
        subtitleLabel.text = subtitle
    }
    func set(price: String?) {
        priceLabel.text = price
        priceLabel.isHidden = price == nil
    }
    func set(imageUrl: String?) {
        if let path = imageUrl,
           let url = URL(string: path) {
            Nuke.loadImage(with: url, into: imageView)
        }
    }
    func set(isTracked: Bool) {
        heartButton.isActive = isTracked
    }
}

