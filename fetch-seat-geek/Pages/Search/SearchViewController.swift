//
//  SearchViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit
import RxSwift
import Nuke

final class SearchViewController: UIViewController, ViewModeled {
    
    // MARK: - Properties | ViewModel
    
    struct Model: DataModel {
        var results: [SGEventSummary] = []
    }
    
    enum Interaction {
        case viewLoaded
        case eventTapped(id: Int)
        case searchTermChanged(text: String?)
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: AnyViewModel<SearchViewController>
    
    // MARK: - Properties | UI Components
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(
            SearchEntryCell.self,
            forCellReuseIdentifier: SearchEntryCell.cellId)
        return table
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.addArrangedSubview(searchBar)
        stack.addArrangedSubview(table)
        return stack
    }()
    
    private let searchBar = SearchBarView()
    
    // MARK: - Lifecycle
    
    init(viewModel: AnyViewModel<SearchViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(contentStack)
        contentStack.anchorInSafeArea(of: view)
        searchBar.anchor(height: 60)
        searchBar.onTextChanged = { [weak self] text in
            self?.viewModel.send(.searchTermChanged(text: text))
        }
        bindViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.send(.viewLoaded)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
                self?.push(viewController: vc)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func onModelChanged(model: Model) {
        table.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.value.results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = viewModel.value.results.elementIfExists(index: indexPath.row) {
            viewModel.send(.eventTapped(id: event.id))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: SearchEntryCell.cellId,
                    for: indexPath) as? SearchEntryCell,
              let data = viewModel.value.results.elementIfExists(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.setup(title: data.title, imageUrl: data.imageUrl)
        cell.selectionStyle = .none
        return cell
    }
}
