//
//  TrackedViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/21/21.
//

import UIKit
import RxSwift
import Nuke

final class TrackedViewController: UIViewController, ViewModeled {
    
    // MARK: - Properties | ViewModel
    
    struct TrackedEvent: Equatable {
        var id: Int
        var title: String
        var subtitle: String
        var price: String?
        var imageUrl: String?
        var isTracked: Bool
    }
    
    struct Model: DataModel {
        var pageTitle: String?
        var events: [TrackedEvent] = []
    }
    
    enum Interaction {
        case viewLoaded
        case eventTapped(id: Int)
    }
    
    // MARK: - Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: AnyViewModel<TrackedViewController>
    
    // MARK: - Properties | UI Components
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundView = UIView()
        table.delegate = self
        table.dataSource = self
        table.register(
            TrackedEntryCell.self,
            forCellReuseIdentifier: TrackedEntryCell.cellId)
        return table
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: AnyViewModel<TrackedViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(table)
        table.anchorInSafeArea(of: view)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
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
        title = model.pageTitle
    }
}

extension TrackedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.value.events.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = viewModel.value.events.elementIfExists(index: indexPath.row) {
            viewModel.send(.eventTapped(id: event.id))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
                .dequeueReusableCell(
                    withIdentifier: TrackedEntryCell.cellId,
                    for: indexPath) as? TrackedEntryCell,
              let data = viewModel.value.events.elementIfExists(index: indexPath.row) else {
            return UITableViewCell()
        }
        cell.setup(
            title: data.title,
            subtitle: data.subtitle,
            price: data.price,
            imageUrl: data.imageUrl,
            isTracked: data.isTracked)
        cell.selectionStyle = .none
        return cell
    }
}
