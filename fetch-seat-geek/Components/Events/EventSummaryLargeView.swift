//
//  EventSummaryLargeView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit
import Nuke

final class EventSummaryLargeView: UIView {
    
    // MARK: - Properties | Components
    
    private let bannerView = TitledBannerView()
    private let priceTagView = PriceTagView(backgroundColor: R.color.brand() ?? .black)
    private let heartButton = HeartButton(isActive: false)
    private let titleLabel = UILabel().styled(with: .largeEventTitle)
    private let subtitleLabel = UILabel().styled(with: .largeEventSubtitle)
    private let backgroundImageView: TintedImageView = {
        let imageView = TintedImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 6
        stack.addArrangedSubview(priceTagView)
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    // MARK: - Properties
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = AppConstants.Dates.Formats.shortDate
        return formatter
    }()
    
    // MARK: - Lifecycle
    
    init(event: SGEventSummary? = nil) {
        super.init(frame: .zero)
        addSubview(backgroundImageView)
        addSubview(infoStack)
        addSubview(bannerView)
        addSubview(heartButton)
                
        infoStack.anchor(
            in: self,
            to: [.left(), .right(), .bottom()],
            padding: .init(constant: 12))
        
        bannerView.anchor(
            in: self,
            to: [.left(), .top()],
            padding: .init(constant: 12))
        bannerView.height(multiplier: 0.1, relativeTo: self)
        
        heartButton.anchor(
            in: self,
            to: [.right(), .top()],
            padding: .init(constant: 12))
        heartButton.aspectRatioSquare()
        heartButton.height(multiplier: 0.1, relativeTo: self)
        backgroundImageView.anchor(in: self)
        
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
        subtitleLabel.text = "\(date) • \(event.venueName), \(event.venueLocation)"
    }
    
    private func dateString(from date: Date) -> String {
        if Calendar.current.isDateInTomorrow(date) {
            return R.string.general.tomorrow()
        }
        return dateFormatter.string(from: date)
    }
    
    private func setupHeartButton(by event: SGEventSummary) {
        heartButton.isHidden = !event.canBeTracked
        heartButton.isActive = event.isTracked
    }
    
    private func setupBanner(by banner: SGBanner?) {
        bannerView.isHidden = banner == nil
        bannerView.set(title: banner?.text ?? "")
        bannerView.style(with: .init(
                            titleColor: banner?.textColor ?? .black,
                            font: banner?.font ?? .systemFont(ofSize: 15),
                            backgroundColor: banner?.backgroundColor ?? .clear))
    }
}
