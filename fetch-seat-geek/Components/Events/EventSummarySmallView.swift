//
//  EventSummarySmallView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit
import Nuke

final class EventSummarySmallView: UIView {
    
    // MARK: - Properties | Components
    
    private let bannerView = TitledBannerView()
    private let priceTagView = PriceTagView()
    private let heartButton = HeartButton(isActive: false)
    private let titleLabel = UILabel().styled(with: .smallEventTitle)
    private let subtitleLabel = UILabel().styled(with: .smallEventSubtitle)
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var infoStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fill
        stack.spacing = 6
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.addArrangedSubview(topSectionView)
        stack.addArrangedSubview(infoStack)
        return stack
    }()
    
    private lazy var topSectionView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        let darkenView = UIView()
        darkenView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(backgroundImageView)
        view.addSubview(darkenView)
        view.addSubview(bannerView)
        view.addSubview(heartButton)
        view.addSubview(priceTagView)
        
        backgroundImageView.anchor(in: view)
        darkenView.anchor(in: backgroundImageView)
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
        heartButton.height(multiplier: 0.125, relativeTo: view)
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
    
    init(event: SGEventSummary) {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self, padding: .init(constant: 8))
        
        setup(using: event)
        
        Nuke.loadImage(
            with: URL(string: event.imageUrl)!,
            into: backgroundImageView)
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
        priceTagView.set(price: event.ticketPrice)
        titleLabel.text = event.title
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

