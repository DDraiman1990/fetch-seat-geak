//
//  EventSummarySmallView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit
import Nuke

final class EventSummarySmallView: UIView {
    var trackTapped: (() -> Void)?

    // MARK: - Properties | Components
    
    private let bannerView = TitledBannerView()
    private let priceTagView = PriceTagView()
    private let heartButton = HeartButton(isActive: false)
    private let titleLabel = UILabel().styled(with: .smallEventTitle)
    private let subtitleLabel = UILabel().styled(with: .smallEventSubtitle)
    private let backgroundImageView: TintedImageView = {
        let imageView = TintedImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 2
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 14
        stack.addArrangedSubview(topSectionView)
        stack.addArrangedSubview(infoStack)
        return stack
    }()
    
    private lazy var topSectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.addSubview(bannerView)
        view.addSubview(heartButton)
        view.addSubview(priceTagView)
        
        backgroundImageView.anchor(in: view)
        bannerView.anchor(
            in: view,
            to: [.left(), .top()],
            padding: .init(constant: 12))
        bannerView.height(multiplier: 0.125, relativeTo: view)
        heartButton.anchor(
            in: view,
            to: [.right(), .top()],
            padding: .init(constant: 12))
        heartButton.aspectRatioSquare()
        heartButton.height(multiplier: 0.2, relativeTo: view)
        priceTagView.anchor(
            in: view,
            to: [.left(), .bottom()],
            padding: .init(constant: 12))
        return view
    }()
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstants.Dates.Formats.dayWithShortSlashDate
        return formatter
    }()

    // MARK: - Lifecycle
    
    init(event: SGEventSummary? = nil) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self,
                            to: [.top(), .right(), .left(), .ltBottom()],
                            padding: .init(top: 0, left: 0, bottom: 12, right: 0))
        backgroundImageView.height(multiplier: 0.55, relativeTo: self)
        
        heartButton.addTarget(self,
                              action: #selector(heartTapped),
                              for: .touchUpInside)
        
        if let event = event {
            setup(using: event)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setup
    
    func setup(using event: SGEventSummary) {
        setupBanner(by: event.banner)
        setupHeartButton(by: event)
        setupSubtitle(from: event)
        if let ticketPrice = event.ticketPrice {
            priceTagView.set(price: ticketPrice)
        }
        priceTagView.isHidden = event.ticketPrice == nil
        titleLabel.text = event.title
        Nuke.loadImage(
            with: URL(string: event.imageUrl)!,
            into: backgroundImageView)
    }
    
    private func setupSubtitle(from event: SGEventSummary) {
        let date = dateString(from: event.date)
        subtitleLabel.text = "\(date) • \(event.venueLocation)"
    }
    
    private func dateString(from date: Date) -> String {
        if Calendar.current.isDateInTomorrow(date) {
            return R.string.general.tomorrow()
        }
        return dateFormatter.string(from: date)
    }
    
    private func setupHeartButton(by event: SGEventSummary) {
        heartButton.isHidden = !event.canBeTracked
    }
    
    func set(isTracked: Bool) {
        heartButton.isActive = isTracked
    }
    
    private func setupBanner(by banner: SGBanner?) {
        bannerView.isHidden = banner == nil
        bannerView.set(title: banner?.text ?? "")
        bannerView.style(with: .init(
                            titleColor: banner?.textColor ?? .black,
                            font: banner?.font ?? .systemFont(ofSize: 15),
                            backgroundColor: banner?.backgroundColor ?? .clear))
    }
    
    @objc private func heartTapped() {
        trackTapped?()
    }
}

