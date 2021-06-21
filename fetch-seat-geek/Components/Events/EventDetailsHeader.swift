//
//  EventDetailsHeader.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class EventDetailsHeader: UIView {
    private let titleLabel = UILabel().styled(with: .eventDetailsTitle)
    private let subtitleLabel = UILabel().styled(with: .eventDetailsSubtitle)
    private let trackingButton = ActionButton(
        title: R.string.general.track(),
        icon: R.image.heart(),
        backgroundColor: R.color.heartRed() ?? .black)
    private let shareButton = ActionButton(
        title: R.string.general.share(),
        icon: R.image.squareAndArrowUp(),
        backgroundColor: R.color.seatGeekBlue() ?? .black)
    
    private lazy var labelsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
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
        stack.addArrangedSubview(labelsStack)
        stack.addArrangedSubview(buttonsStack)
        return stack
    }()
    
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
    }
}
