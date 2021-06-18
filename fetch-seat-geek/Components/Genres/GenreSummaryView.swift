//
//  GenreSummaryView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit
import Nuke

final class GenreSummaryView: UIView {
    private let titleLabel = UILabel().styled(with: .genreTitle)
    private let backgroundImage: TintedImageView = {
        let imageView = TintedImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    init(genre: SGGenre? = nil) {
        super.init(frame: .zero)
        addSubview(backgroundImage)
        addSubview(titleLabel)
        backgroundImage.anchor(in: self)
        clipsToBounds = true
        layer.cornerRadius = 6
        titleLabel.anchor(
            in: self,
            to: [.left(), .right(), .bottom(), .gtTop()],
            padding: .init(constant: 12))
        if let genre = genre {
            setup(genre: genre)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(genre: SGGenre) {
        self.titleLabel.text = genre.name
        if let url = URL(string: genre.image ?? "") {
            Nuke.loadImage(with: url, into: backgroundImage)
        }
    }
}
