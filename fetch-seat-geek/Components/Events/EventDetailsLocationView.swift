//
//  EventDetailsLocationView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//

import UIKit

final class EventDetailsLocationView: UIView {
    enum TravelTime {
        case drive, walk
    }
    var onViewAllTapped: (() -> Void)?
    var onTravelTimeTapped: ((TravelTime) -> Void)?
    private let titleLabel = UILabel().styled(with: .eventDetailsTitle)
    private let locationNameLabel = UILabel().styled(with: .eventDetailsSubtitle)
    private let locationLabel = UILabel().styled(with: .eventDetailsSubtitle)
    private let driveTravelTimeView = TravelTimeView(
        title: R.string.general.drive(),
        travelTime: "\(Int.random(in: 1...4)), \(Int.random(in: 1...58)) min",
        icon: R.image.car())
    private let walkTravelTimeView = TravelTimeView(
        title: R.string.general.walk(),
        travelTime: "\(Int.random(in: 10...40)), \(Int.random(in: 1...58)) min",
        icon: R.image.pedestrian())
    private let trackingButton = ActionButton(
        title: R.string.general.track(),
        icon: R.image.heart(),
        backgroundColor: R.color.heartRed() ?? .black)
    private let shareButton = ActionButton(
        title: R.string.general.share(),
        icon: R.image.squareAndArrowUp(),
        backgroundColor: R.color.seatGeekBlue() ?? .black)

    private let viewAllView = SeeMoreView(title: "")
    
    private lazy var locationStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.addArrangedSubview(locationNameLabel)
        stack.addArrangedSubview(locationLabel)
        return stack
    }()
    
    private lazy var travelTimeStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 8
        stack.addArrangedSubview(driveTravelTimeView)
        stack.addArrangedSubview(walkTravelTimeView)
        return stack
    }()
    
    private let viewAllStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(locationStack)
        stack.addArrangedSubview(travelTimeStack)
        stack.addArrangedSubview(viewAllView)
        return stack
    }()
    
    init(locationName: String,
         location: String) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(
            in: self,
            padding: .init(horizontal: 12, vertical: 18))
        titleLabel.text = R.string.general.location()
        set(location: location)
        set(locationName: locationName)
        
        viewAllView.onTapped = { [weak self] in
            self?.onViewAllTapped?()
        }
        
        driveTravelTimeView.onTapped = { [weak self] in
            self?.onTravelTimeTapped?(.drive)
        }
        walkTravelTimeView.onTapped = { [weak self] in
            self?.onTravelTimeTapped?(.walk)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(location: String) {
        locationLabel.text = location
    }
    
    func set(locationName: String) {
        locationNameLabel.text = locationName
    }
    
    @objc private func viewAllTapped() {
        onViewAllTapped?()
    }
}
