//
//  TitledBannerView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class TitledBannerView: UIView {
    struct Style {
        var titleColor: UIColor = .white
        var font: UIFont = .systemFont(ofSize: 15)
        var backgroundColor: UIColor = .black
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    init(title: String = "",
         style: Style = .init()) {
        super.init(frame: .zero)
        addSubview(titleLabel)
        titleLabel.anchor(
            in: self,
            padding: .init(horizontal: 8, vertical: 2))
        set(title: title)
        self.style(with: style)
    }
    
    func set(title: String) {
        titleLabel.text = title
    }
    
    func style(with style: Style) {
        self.backgroundColor = style.backgroundColor
        titleLabel.font = style.font
        titleLabel.textColor = style.titleColor
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 4
    }
}
