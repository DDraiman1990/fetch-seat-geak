//
//  LargeTitledNavigationBar.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class LargeTitledNavigationBar: UIView {
    enum NavigationBarMode {
        case large, compact
    }
    
    private var state: NavigationBarMode = .large {
        didSet {
            stateChanged(from: oldValue, to: state)
        }
    }
    
    var onTitlesTapped: (() -> Void)?
    var onActionButtonTapped: (() -> Void)?
    private let barHeight: CGFloat
    private var heightConstraint: NSLayoutConstraint!
    
    struct ButtonStyle {
        var color: UIColor = .blue
        var type: ButtonType
    }
    
    enum ButtonType {
        case text(title: String, font: UIFont?)
        case icon(image: UIImage?)
    }
    
    private let largeTitlesTapRecognizer = UITapGestureRecognizer()
    private let compactTitlesTapRecognizer = UITapGestureRecognizer()
    
    private let largeTitleLabel: UILabel = UILabel()
        .styled(with: .navBarLargeTitle)
    private let largeSubtitleLabel: UILabel = UILabel()
        .styled(with: .navBarLargeSubtitle)
    private let compactTitleLabel: UILabel = UILabel()
        .styled(with: .navBarCompactTitle)
    private let compactSubtitleLabel: UILabel = UILabel()
        .styled(with: .navBarCompactSubtitle)
    
    private lazy var largeTitlesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.addArrangedSubview(largeTitleLabel)
        stack.addArrangedSubview(largeSubtitleLabel)
        return stack
    }()
    
    private lazy var compactTitlesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.addArrangedSubview(compactTitleLabel)
        stack.addArrangedSubview(compactSubtitleLabel)
        return stack
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
        return button
    }()
    
    init(
        title: String,
        subtitle: String,
        buttonStyle: ButtonStyle,
        height: CGFloat) {
        self.barHeight = height
        super.init(frame: .zero)
        addSubview(actionButton)
        actionButton.width(multiplier: 0.1, relativeTo: self)
        
        addSubview(largeTitlesStack)
        addSubview(compactTitlesStack)
        
        largeTitlesTapRecognizer.addTarget(self, action: #selector(titlesTapped))
        compactTitlesTapRecognizer.addTarget(self, action: #selector(titlesTapped))
        largeTitlesStack.addGestureRecognizer(largeTitlesTapRecognizer)
        compactTitlesStack.addGestureRecognizer(compactTitlesTapRecognizer)
        actionButton.anchor(
            in: self,
            to: [.right(), .top(), .bottom()],
            padding: .init(horizontal: 18, vertical: 8))
        
        largeTitlesStack.anchor(
            in: self,
            to: [.left(), .top(), .bottom()],
            padding: .init(horizontal: 18, vertical: 8))
        compactTitlesStack.anchor(
            in: self,
            to: [.gtLeft(), .top(), .bottom()],
            padding: .init(horizontal: 18, vertical: 8))
        compactTitlesStack.centerX(in: self)
        largeTitlesStack.anchor(
            edge: .right(),
            to: .left(),
            sibling: actionButton,
            padding: 16)
        compactTitlesStack.anchor(
            edge: .gtRight(),
            to: .left(),
            sibling: actionButton,
            padding: 16)
        set(title: title)
        set(subtitle: subtitle)
        set(buttonStyle: buttonStyle)
        showLarge()
        
        heightConstraint = heightAnchor.constraint(equalToConstant: barHeight)
        heightConstraint.isActive = true
    }
    
    func set(title: String) {
        largeTitleLabel.text = title
        compactTitleLabel.text = title
    }
    
    func set(subtitle: String) {
        largeSubtitleLabel.text = subtitle
        compactSubtitleLabel.text = subtitle
    }
    
    func set(buttonStyle: ButtonStyle) {
        actionButton.tintColor = buttonStyle.color
        actionButton.setTitleColor(buttonStyle.color, for: .normal)
        switch buttonStyle.type {
        case .icon(let image):
            actionButton.setTitle(nil, for: .normal)
            actionButton.setImage(image, for: .normal)
        case .text(let title, let font):
            actionButton.setTitle(title, for: .normal)
            actionButton.titleLabel?.font = font
        }
    }
    
    private func showCompact() {
        self.compactTitlesStack.alpha = 1
        self.largeTitlesStack.alpha = 0
    }
    
    private func showLarge() {
        self.compactTitlesStack.alpha = 0
        self.largeTitlesStack.alpha = 1
    }
    
    private func stateChanged(from: NavigationBarMode, to: NavigationBarMode) {
        switch state {
        case .compact:
            UIView.animate(withDuration: 0.66) {
                self.showCompact()
            }
        case .large:
            UIView.animate(withDuration: 0.66) {
                self.showLarge()
            }
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func actionTapped() {
        onActionButtonTapped?()
    }
    
    @objc private func titlesTapped() {
        onTitlesTapped?()
    }
    
    func onScrollOffsetChanged(_ offset: CGPoint) {
        let constant = (barHeight - offset.y)
            .clamp(lower: 50, upper: barHeight)
        heightConstraint.constant = constant
        if heightConstraint.constant >= barHeight - 10 {
            state = .large
        } else {
            state = .compact
        }
    }
}
