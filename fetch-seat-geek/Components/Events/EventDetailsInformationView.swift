//
//  EventDetailsInformationView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class EventDetailsInformationView: UIView {
    
    // MARK: - Properties
    
    var onTrackingTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    
    // MARK: - UI Components
    
    private let titleLabel = UILabel().styled(with: .eventDetailsTitle)
    private let subtitleLabel = UILabel().styled(with: .eventDetailsSubtitle)
    private lazy var trackingButton: ActionButton = {
        let button = ActionButton(
            title: R.string.general.track(),
            icon: R.image.heart(),
            backgroundColor: R.color.heartRed() ?? .black)
        button.addTarget(self, action: #selector(trackingTapped))
        return button
    }()
    private lazy var shareButton: ActionButton = {
        let button = ActionButton(
            title: R.string.general.share(),
            icon: R.image.squareAndArrowUp(),
            backgroundColor: R.color.seatGeekBlue() ?? .black)
        button.addTarget(self, action: #selector(shareTapped))
        return button
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(trackingButton)
        stack.addArrangedSubview(shareButton)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .leading
        stack.addArrangedSubview(labelsStack)
        stack.addArrangedSubview(buttonsStack)
        return stack
    }()
    
    // MARK: - Lifecycle
    
    init(title: String,
         subtitle: String,
         isTracked: Bool) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(horizontal: 12, vertical: 18))
        set(title: title)
        set(subtitle: subtitle)
        set(isTracked: isTracked)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setters
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func set(subtitle: String) {
        subtitleLabel.text = subtitle
    }
    
    func set(isTracked: Bool) {
        trackingButton.set(icon: isTracked ?
                            R.image.suitHeartFill() :
                            R.image.heart())
        trackingButton.set(title: isTracked ?
                            R.string.general.tracking():
                            R.string.general.track())
    }
    
    // MARK: - Methods | Actions
    
    @objc private func shareTapped() {
        onShareTapped?()
    }
    
    @objc private func trackingTapped() {
        onTrackingTapped?()
    }
}
