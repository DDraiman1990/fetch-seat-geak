//
//  PriceTagView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class PriceTagView: UIView {
    
    // MARK: - UIComponents
    
    private let priceLabel: UILabel = UILabel().styled(with: .priceBanner)
    private var path: UIBezierPath = .init()
    private let shapeLayer: CAShapeLayer = .init()
    
    // MARK: - Lifecycle
    
    init(
        price: String = "",
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)) {
        super.init(frame: .zero)
        addSubview(priceLabel)
        priceLabel.anchor(
            in: self,
            padding: .init(horizontal: 8, vertical: 2))
        set(price: price)
        shapeLayer.fillColor = backgroundColor.cgColor
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight, .bottomRight],
            cornerRadii: CGSize(width: frame.height / 2, height: frame.height / 2))
            .cgPath
    }
    
    // MARK: - Methods | Setters
    
    func set(price: String) {
        priceLabel.text = "$\(price)"
    }
}
