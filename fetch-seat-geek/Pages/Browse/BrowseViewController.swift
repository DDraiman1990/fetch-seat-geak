//
//  BrowseViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/17/21.
//

import UIKit
import RxSwift

final class BrowseViewController: UIViewController, ViewModeled {
    
    // MARK: - Properties | ViewModel
    
    private let viewModel: AnyViewModel<BrowseViewController>

    struct Model: DataModel {
        var location: String = ""
        var dates: String = ""
        var sections: [BrowseSection] = []
        var trackedIds: Set<Int> = []
    }
    
    enum Interaction {
        case viewLoaded
        case viewAppeared
        case onTapped(row: Int, section: BrowseSection)
        case trackTappedFor(id: Int)
        case tappedViewAll(section: BrowseSection)
        case tappedDateAndLocation
    }
    
    // MARK: - Properties | UI Components
    
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
    
    private let navBar: LargeTitledNavigationBar = {
        let bar = LargeTitledNavigationBar(title: "", subtitle: "", buttonStyle: .init(color: .blue, type: .icon(image: R.image.hamburgerMenu())), height: 80)
        return bar
    }()
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(viewModel: AnyViewModel<BrowseViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(contentStack)
        contentStack.anchorInSafeArea(of: view)
        bindViewModel()
        
        navBar.onActionButtonTapped = {
            viewModel.send(.tappedDateAndLocation)
        }
        navBar.onTitlesTapped = {
            viewModel.send(.tappedDateAndLocation)
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods | Setup
    
    private func bindViewModel() {
        viewModel
            .valuePublisher
            .observe(on: MainScheduler.instance)
            .subscribeToValue { [weak self] model in
                self?.onModelChanged(model: model.newValue)
        }
        .disposed(by: disposeBag)
        
        viewModel
            .presentPublisher
            .observe(on: MainScheduler.instance)
            .subscribeToValue { [weak self] vc in
                self?.push(viewController: vc, animated: true)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
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
        let cell = section.dequeue(
            from: table,
            indexPath: indexPath,
            trackedIds: viewModel.value.trackedIds)
        (cell as? ViewAllHeaderCell)?.onActionTapped = { [weak self] in
            self?.viewModel.send(.tappedViewAll(section: section))
        }
        (cell as? CollectionViewContaining)?.onSelectedItem = { [weak self] ip in
            self?.viewModel.send(.onTapped(row: ip.item, section: section))
        }
        (cell as? TrackableView)?.trackTapped = { [weak self] id in
            self?.viewModel.send(.trackTappedFor(id: id))
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

extension BrowseViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navBar.onScrolling(contentOffset: scrollView.contentOffset, contentInset: scrollView.contentInset)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        navBar.onScrollingStopped(contentOffset: scrollView.contentOffset, contentInset: scrollView.contentInset)
    }
}
