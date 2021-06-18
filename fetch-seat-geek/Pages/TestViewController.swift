//
//  TestViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/16/21.
//

import UIKit

final class TestViewController: UIViewController {
    struct Item: IdentifiableItem {
        var id: String
        var title: String
        var subtitle: String
        
        static func stub(rand: Bool) -> Item {
            return .init(id: UUID().uuidString, title: "\(rand ? 10 : Int.random(in: 0...30))", subtitle: "\(Bool.random())")
        }
    }
    private lazy var oneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("One", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(onOneTapped), for: .touchUpInside)
        return button
    }()
    private lazy var twoButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Randomize", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(onTwoTapped), for: .touchUpInside)
        return button
    }()
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.addArrangedSubview(oneButton)
        stack.addArrangedSubview(twoButton)
        return stack
    }()
    let collection = CollectionView<TestCell, Int, Item>(layout: UICollectionViewFlowLayout(), sizeForItem: { item, indexPath in
        return .init(width: 100, height: 100)
    }) { cell, indexPath, item -> UICollectionViewCell in
        (cell as? TestCell)?.setup(item: item)
        return cell
    }
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.anchorInSafeArea(of: view, to: [.top(), .right(), .left()])
        view.addSubview(buttonsStack)
        buttonsStack.anchorInSafeArea(
            of: view,
            to: [.bottom(), .right(), .left()],
            padding: .init(constant: 16))
        buttonsStack.anchor(edge: .top(), to: .bottom(), sibling: collection, padding: 16)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onOneTapped() {
        useSetOne.toggle()
        useSetOne ? set1() : set2()
    }
    @objc private func onTwoTapped() {
        randomize()
    }
    
    private var useSetOne: Bool = true
    
    private let pool = Array(0...50).map {
        Item(id: "\($0)", title: "\($0)", subtitle: "\($0)")
    }
    private func set1() {
        collection.set(sections: [
            .init(section: 0, items: [
                .init(id: "1", title: "1", subtitle: "One"),
                .init(id: "3", title: "3", subtitle: "Three")
            ]),
            .init(section: 1, items: [
                .init(id: "9", title: "9", subtitle: "Four"),
                .init(id: "7", title: "7", subtitle: "Two"),
                .init(id: "8", title: "8", subtitle: "Three"),
            ]),
            .init(section: 2, items: [
                .init(id: "12", title: "7", subtitle: "Two"),
                .init(id: "13", title: "8", subtitle: "Three"),
                .init(id: "11", title: "9", subtitle: "Four"),
            ])
        ])
    }
    
    private func set2() {
        collection.set(sections: [
            .init(section: 0, items: [
                .init(id: "3", title: "3", subtitle: "Three"),
                .init(id: "4", title: "4", subtitle: "Four"),
            ]),
            .init(section: 1, items: [
                .init(id: "8", title: "8", subtitle: "Three"),
                .init(id: "9", title: "9", subtitle: "Four"),
                .init(id: "7", title: "7", subtitle: "Two"),
            ]),
            .init(section: 2, items: [
                .init(id: "11", title: "9", subtitle: "Four"),
                .init(id: "12", title: "7", subtitle: "Two"),
                .init(id: "13", title: "8", subtitle: "Three"),
            ]),
            .init(section: 3, items: [
                .init(id: "21", title: "9", subtitle: "Four"),
                .init(id: "32", title: "7", subtitle: "Two"),
                .init(id: "513", title: "8", subtitle: "Three"),
            ])
        ])
    }
    
    private func randomize() {
        let chunked = pool
            .shuffled()
            .chunked(into: Int.random(in: 1...5))
            .enumerated()
            .map { chunk -> DiffableDataSource<Int, Item>.SectionEntry in
                return .init(section: chunk.offset, items: chunk.element)
            }
        collection.set(sections: chunked)
    }
}

final class TestCell: IdentifiableCollectionCell {
    public static let cellId = "TestCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(contentStack)
        contentStack.anchor(in: contentView)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(item: TestViewController.Item) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
