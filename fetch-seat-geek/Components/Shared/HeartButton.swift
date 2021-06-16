//
//  HeartButton.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class HeartButton: UIButton {
    private let activeIcon = UIImage(systemName: "suit.heart.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    private let inactiveIcon = UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))
    
    var isActive: Bool = false {
        didSet {
            onStateChanged()
        }
    }
    
    init(isActive: Bool) {
        super.init(frame: .zero)
        onStateChanged()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func onStateChanged() {
        setImage(isActive ? activeIcon : inactiveIcon, for: .normal)
    }
}
