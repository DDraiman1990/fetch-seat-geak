//
//  StretchingHeaderView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

class StretchingHeaderView: UIView, ScrollAware {
    
    // MARK: - Components
    
    private var contentHeightConstraint: NSLayoutConstraint!
    private var contentBottomConstraint: NSLayoutConstraint!
    private var containerHeightConstraint: NSLayoutConstraint!

    private var contentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let content: UIView
    
    // MARK: - Lifecycle
    
    init(content: UIView, initialHeight: CGFloat = 60) {
        self.content = content
        super.init(frame: .init(x: 0, y: 0, width: 0, height: initialHeight))
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentContainer)
        contentContainer.addSubview(content)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            contentContainer.widthAnchor.constraint(equalTo: widthAnchor),
            contentContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentContainer.heightAnchor.constraint(equalTo: heightAnchor)
        ])
                
        contentContainer.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        containerHeightConstraint = contentContainer.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerHeightConstraint.isActive = true
        
        contentBottomConstraint = content.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor)
        contentBottomConstraint.isActive = true
        contentHeightConstraint = content.heightAnchor.constraint(equalTo: contentContainer.heightAnchor)
        contentHeightConstraint.isActive = true
    }
    
    func onScrolling(contentOffset: CGPoint, contentInset: UIEdgeInsets) {
        contentHeightConstraint.constant = contentInset.top
        let offsetY = -(contentOffset.y + contentInset.top)
        contentContainer.clipsToBounds = offsetY <= 0
        contentBottomConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        contentHeightConstraint.constant = max(offsetY + contentInset.top, contentInset.top)
    }
}
