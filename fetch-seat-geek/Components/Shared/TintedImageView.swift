//
//  TintedImageView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/18/21.
//

import UIKit

final class TintedImageView: UIImageView {
    
    // MARK: - UI Components
    
    private let tintView = UIView()
    private let imageView: UIImageView = UIImageView()
    
    // MARK: - Properties
    override var contentMode: UIView.ContentMode {
        get {
            imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
        }
    }
    var imageTintColor: UIColor? {
        get {
            tintView.backgroundColor
        }
        set {
            tintView.backgroundColor = newValue
        }
    }
    
    override var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }

    // MARK: - Lifecycle
    
    init(
        image: UIImage? = nil,
        tintColor: UIColor = UIColor.black.withAlphaComponent(0.3)) {
        super.init(frame: .zero)
        addSubview(imageView)
        addSubview(tintView)
        imageView.anchor(in: self)
        tintView.anchor(in: imageView)
        self.imageTintColor = tintColor
        imageView.image = image
        imageView.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
