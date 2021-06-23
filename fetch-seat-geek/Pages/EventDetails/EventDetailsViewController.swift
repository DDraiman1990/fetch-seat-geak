//
//  EventDetailsViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/20/21.
//


import UIKit
import RxSwift
import Nuke

final class EventDetailsViewController: UIViewController, ViewModeled {
    // MARK: - Properties | ViewModel
    
    enum Section: Int {
        case eventInfo = 0, location = 1
    }
    
    struct HeaderData: Equatable {
        var title: String
        var subtitle: String
        var isTracked: Bool
    }
    
    struct LocationData: Equatable {
        var locationName: String
        var location: String
        var driveTime: String?
        var walkTime: String?
    }
    
    struct Model: DataModel {
        var headerImageUrl: String?
        var pageTitle: String?
        var headerData: HeaderData?
        var locationData: LocationData?
    }
    
    enum Interaction {
        case viewLoaded
        case shareTapped
        case trackingTapped
        case travelTimeTapped(method: TravelTime)
        case viewAllTapped
    }
    
    // MARK: - Properties
    
    private let headerHeight: CGFloat = 110
    private let disposeBag = DisposeBag()
    private let viewModel: AnyViewModel<EventDetailsViewController>
    var isHeaderVisible: Bool {
        let barPosition = topBar.center.y - topBar.frame.height
        return table.contentOffset.y < barPosition
    }
    
    var isBarTransparent: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // MARK: - Properties | UI Components
    
    private lazy var plainBackBarButton = UIBarButtonItem(image: R.image.chevronLeft(), style: .plain, target: self, action: #selector(backTapped))
    private lazy var styledBackBarButton: UIBarButtonItem = {
        let button = UIButton()
        button.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        button.layer.cornerRadius = 12
        button.setImage(R.image.chevronLeft(), for: .normal)
        button.anchor(height: 46)
        button.anchor(width: 46)
        button.tintColor = .white
        button.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    private lazy var topBar: UINavigationBar = {
        let bar = UINavigationBar()
        let item = UINavigationItem(title: "")
        bar.setItems([item], animated: false)
        item.setLeftBarButton(plainBackBarButton, animated: false)
        return bar
    }()
    private let topBarSafeAreaCoverView = UIView()
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private lazy var header: StretchingHeaderView = {
        let header = StretchingHeaderView(
            content: headerImageView,
            initialHeight: headerHeight)
        return header
    }()
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundView = UIView()
        table.delegate = self
        table.dataSource = self
        table.tableHeaderView = header
        table.register(
            EventDetailsInformationCell.self,
            forCellReuseIdentifier: EventDetailsInformationCell.cellId)
        table.register(
            EventDetailsLocationCell.self,
            forCellReuseIdentifier: EventDetailsLocationCell.cellId)
        return table
    }()
    
    // MARK: - Lifecycle
    
    init(viewModel: AnyViewModel<EventDetailsViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(table)
        view.addSubview(topBar)
        view.addSubview(topBarSafeAreaCoverView)
        topBar.anchorInSafeArea(of: view, to: [.top(), .left(), .right()])
        topBar.anchor(height: 44)
        topBarSafeAreaCoverView.anchor(in: view, to: [.top(), .left(), .right()])
        topBarSafeAreaCoverView.anchor(edge: .bottom(), to: .top(), sibling: topBar)
        table.anchor(in: view)
        bindViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.send(.viewLoaded)
        setTransparentNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Methods | Navigation bar
    
    private func setTransparentNavigationBar() {
        if isBarTransparent {
            return
        }
        isBarTransparent = true
        topBar.backgroundColor = .clear
        topBar.isTranslucent = true
        topBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        topBar.shadowImage = UIImage()
        topBar.items?.first?.title = nil
        topBarSafeAreaCoverView.backgroundColor = .clear
        topBar.items?.first?.setLeftBarButton(styledBackBarButton, animated: true)
    }
    
    private func setVisibleNavigationBar() {
        if !isBarTransparent {
            return
        }
        isBarTransparent = false
        topBar.items?.first?.title = viewModel.value.pageTitle
        topBar.backgroundColor = .white
        topBar.isTranslucent = false
        topBarSafeAreaCoverView.backgroundColor = topBar.backgroundColor
        topBar.items?.first?.setLeftBarButton(plainBackBarButton, animated: true)
    }
    
    // MARK: - Methods | Styling
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isBarTransparent ? .lightContent : .default
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
                self?.present(vc, animated: true, completion: nil)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - Methods | Helpers
    
    private func onModelChanged(model: Model) {
        table.reloadData()
        if let url = URL(string: model.headerImageUrl ?? "") {
            Nuke.loadImage(with: url, into: headerImageView)
        }
    }
    
    // MARK: - Methods | Actions
    
    @objc private func backTapped() {
        self.pop(animated: true)
    }
}

extension EventDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .eventInfo:
            if viewModel.value.headerData != nil {
                return 1
            }
            return 0
        case .location:
            if viewModel.value.locationData != nil {
                return 1
            }
            return 0
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isHeaderVisible {
            setTransparentNavigationBar()
        } else {
            setVisibleNavigationBar()
        }
        header.onScrolling(
            contentOffset: scrollView.contentOffset,
            contentInset: scrollView.contentInset)
    }
    
    private func dequeueLocationCell(
        locationData: LocationData,
        indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = table
                .dequeueReusableCell(
                    withIdentifier: EventDetailsLocationCell.cellId,
                    for: indexPath) as? EventDetailsLocationCell else {
            return UITableViewCell()
        }
        cell.setup(locationName: locationData.locationName,
                   location: locationData.location,
                   driveTime: locationData.driveTime,
                   walkTime: locationData.walkTime)
        cell.selectionStyle = .none
        cell.onTravelTimeTapped = { [weak self] method in
            self?.viewModel.send(.travelTimeTapped(method: method))
        }
        cell.onViewAllTapped = { [weak self] in
            self?.viewModel.send(.viewAllTapped)
        }
        return cell
    }
    
    private func dequeueInformationCell(
        headerData: HeaderData,
        indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = table
                .dequeueReusableCell(
                    withIdentifier: EventDetailsInformationCell.cellId,
                    for: indexPath) as? EventDetailsInformationCell else {
            return UITableViewCell()
        }
        cell.setup(
            title: headerData.title,
            subtitle: headerData.subtitle,
            isTracked: headerData.isTracked)
        cell.selectionStyle = .none
        cell.onShareTapped = { [weak self] in
            self?.viewModel.send(.shareTapped)
        }
        cell.onTrackingTapped = { [weak self] in
            self?.viewModel.send(.trackingTapped)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .eventInfo:
            guard let headerData = viewModel.value.headerData else {
                return UITableViewCell()
            }
            return dequeueInformationCell(
                headerData: headerData,
                indexPath: indexPath)
        case .location:
            guard let locationData = viewModel.value.locationData else {
                return UITableViewCell()
            }
            return dequeueLocationCell(
                locationData: locationData,
                indexPath: indexPath)
        }
    }
}
