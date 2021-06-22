//
//  SearchBarView.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit

final class SearchBarView: UIView {
    var onTextChanged: ((String?) -> Void)?
    private lazy var searchWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = .init(width: 0, height: 0)
        view.addSubview(innerSearchStack)
        innerSearchStack.anchor(
            in: view,
            padding: .init(horizontal: 18, vertical: 8))
        return view
    }()
    
    private lazy var innerSearchStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 6
        stack.addArrangedSubview(searchIconView)
        stack.addArrangedSubview(searchTextField)
        return stack
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 12
        stack.addArrangedSubview(searchWrapper)
        stack.addArrangedSubview(cancelButton)
        return stack
    }()
    
    private let searchIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.magnifyingglass()
        imageView.tintColor = R.color.seatGeekBlue()
        imageView.anchor(width: 36)
        return imageView
    }()
    
    private lazy var searchTextField: UITextField = {
        let view = UITextField()
        view.delegate = self
        view.addTarget(
            nil,
            action: #selector(self.textFieldDidChange),
            for: .editingChanged)
        view.font = R.font.proximaNovaRegular(size: 16)
        view.placeholder = R.string.main.search_placeholder()
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = R.font.proximaNovaSemibold(size: 14)
        button.setTitle(R.string.general.cancel().uppercased(),
                        for: .normal)
        button.setTitleColor(R.color.seatGeekBlue(), for: .normal)
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        addSubview(contentStack)
        contentStack.anchor(in: self,
                            padding: .init(horizontal: 24, vertical: 10))
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        searchWrapper.layer.cornerRadius = searchWrapper.frame.height / 2
    }
    
    @objc private func cancelTapped() {
        endEditing(true)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        onTextChanged?(textField.text)
    }
}

extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.33) {
            self.cancelButton.isHidden = false
            self.contentStack.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.33) {
            self.cancelButton.isHidden = true
            self.contentStack.layoutIfNeeded()
        }
    }
}
