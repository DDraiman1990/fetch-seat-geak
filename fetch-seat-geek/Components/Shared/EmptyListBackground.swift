//
//  EmptyListBackground.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class EmptyListBackground: UIView {
    
    // MARK: - UI Components
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(bodyWrapper)
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bodyWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(bodyLabel)
        bodyLabel.anchor(in: view)
        return view
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.anchor(height: 36)
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    init(title: String?,
         body: String?,
         image: UIImage?) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack
            .anchorYCenteredDynamicHeight(
                in: self,
                padding: .init(constant: 36))
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        bodyLabel.text = body
        bodyWrapper.isHidden = body == nil
        imageView.image = image
        imageView.isHidden = image == nil
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
