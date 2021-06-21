//
//  BrowseViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/17/21.
//

import UIKit
import RxSwift

final class BrowseViewController: UIViewController, ViewModeled {
    private let disposeBag = DisposeBag()
    
    struct Model: DataModel {
        var location: String = ""
        var dates: String = ""
        var sections: [BrowseSection] = []
    }
    
    enum Interaction {
        case viewLoaded
        case viewAppeared
    }
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundView = UIView()
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        return table
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 0
        stack.addArrangedSubview(navBar)
        stack.addArrangedSubview(table)
        return stack
    }()
    
    private let viewModel: AnyViewModel<BrowseViewController>
    private let navBar: LargeTitledNavigationBar = {
        let bar = LargeTitledNavigationBar(title: "", subtitle: "", buttonStyle: .init(color: .blue, type: .icon(image: R.image.hamburgerMenu())), height: 80)
        return bar
    }()
    
    init(viewModel: AnyViewModel<BrowseViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(contentStack)
        contentStack.anchorInSafeArea(of: view)
        bindViewModel()
        
        navBar.onActionButtonTapped = {
            print("Action Tapped")
        }
        navBar.onTitlesTapped = {
            print("Titles Tapped")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.send(.viewLoaded)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        viewModel.send(.viewAppeared)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindViewModel() {
        viewModel
            .valuePublisher
            .observe(on: MainScheduler.instance)
            .subscribeToValue { [weak self] model in
                self?.onModelChanged(model: model.newValue)
        }
        .disposed(by: disposeBag)
    }
    
    private func onModelChanged(model: Model) {
        navBar.set(title: model.location)
        navBar.set(subtitle: model.dates)
        table.reloadData()
    }
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.value.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.value.sections[section].numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = viewModel.value.sections.elementIfExists(index: indexPath.section) else {
            assertionFailure("Failed to dequeue")
            return UITableViewCell()
        }
        let cell = section.dequeue(from: table, indexPath: indexPath)
        (cell as? ViewAllHeaderCell)?.onActionTapped = {
            print("Tapped \(section.header ?? "Unknown Header")")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = viewModel.value.sections.elementIfExists(index: indexPath.section) else {
            assertionFailure("Failed to dequeue")
            return 0
        }
        return section.cellHeight(indexPath: indexPath)
    }
}

final class ViewAllHeaderCell: UITableViewCell {
    public static let cellId = "ViewAllHeaderCell"
    var onActionTapped: (() -> Void)? {
        get {
            view.onActionTapped
        }
        set {
            view.onActionTapped = newValue
        }
    }
    private let view: ViewMoreHeaderView = ViewMoreHeaderView(
        title: "",
        actionTitle: "View All")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(view)
        view.anchor(in: contentView)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String) {
        view.set(title: title)
    }
}

extension BrowseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navBar.onScrolling(contentOffset: scrollView.contentOffset, contentInset: scrollView.contentInset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navBar.onScrollingStopped(contentOffset: scrollView.contentOffset, contentInset: scrollView.contentInset)
    }
}

protocol ScrollAware {
    func onScrolling(
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets)
    func onScrollingStopped(
        contentOffset: CGPoint,
        contentInset: UIEdgeInsets)
}

extension UITableViewCell {
    func hideSeparator() {
        separatorInset = .init(top: 0, left: .infinity, bottom: 0, right: 0)
    }
}
