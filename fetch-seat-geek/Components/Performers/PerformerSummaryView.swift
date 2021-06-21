//
//  PerformerSummaryView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit
import Nuke

final class PerformerSummaryView: UIView {
    private let titleLabel = UILabel().styled(with: .featuredPerformerTitle)
    private let backgroundImage: TintedImageView = {
        let imageView = TintedImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(performer: SGPerformerSummary? = nil) {
        super.init(frame: .zero)
        addSubview(backgroundImage)
        addSubview(titleLabel)
        backgroundImage.anchor(in: self)
        clipsToBounds = true
        layer.cornerRadius = 6
        titleLabel.anchor(
            in: self,
            to: [.left(), .right(), .bottom(), .gtTop()],
            padding: .init(constant: 26))
        if let performer = performer {
            setup(performer: performer)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(performer: SGPerformerSummary) {
        self.titleLabel.text = performer.name
        if let url = URL(string: performer.image) {
            Nuke.loadImage(with: url, into: backgroundImage)
        }
    }
}
