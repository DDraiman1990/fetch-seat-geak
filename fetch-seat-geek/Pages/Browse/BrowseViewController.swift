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
    enum Row: Equatable {
        case featured
        case justForYou
        case trendingEvents
        case recentlyViewed
        case browseCategories
        case justAnnounced
        case category(named: String)
        
        var title: String? {
            switch self {
            case .featured:
                return "Featured"//nil
            case .justForYou:
                return "Just for you"
            case .trendingEvents:
                return "Trending events"
            case .recentlyViewed:
                return "Recently viewed events"
            case .browseCategories:
                return "Browse by category"
            case .justAnnounced:
                return "Just announced"
            case .category(let named):
                return named
            }
        }
    }
    
    struct SectionData: Equatable {
        var header: String?
        var data: Row
        var separator: Bool = true
        var numOfRows: Int {
            return header == nil ? 1 : 2
        }
    }
    
    struct Model: DataModel {
        var sections: [SectionData] = []
    }
    
    enum Interaction {
        
    }
    
    private lazy var table: UITableView = {
        let table = UITableView()
        table.backgroundView = UIView()
        table.register(
            TitledCell.self,
            forCellReuseIdentifier: TitledCell.cellId)
        table.register(
            ViewAllHeaderCell.self,
            forCellReuseIdentifier: ViewAllHeaderCell.cellId)
        table.delegate = self
        table.dataSource = self
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
        let bar = LargeTitledNavigationBar(title: "Joliet, IL", subtitle: "Any Date", buttonStyle: .init(color: .blue, type: .icon(image: R.image.hamburgerMenu())), height: 80)
        return bar
    }()
    
    init(viewModel: AnyViewModel<BrowseViewController>) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        view.addSubview(contentStack)
        contentStack.anchorInSafeArea(of: view)
        setupNavigationBar()
        bindViewModel()
        
        navBar.onActionButtonTapped = {
            print("Action Tapped")
        }
        navBar.onTitlesTapped = {
            print("Titles Tapped")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavigationBar() {
        title = "Joliet, IL"
    }
    
    private func bindViewModel() {
        viewModel
            .valuePublisher
            .observe(on: MainScheduler.instance)
            .subscribeToValue { [weak self] model in
            self?.table.reloadData()
        }
        .disposed(by: disposeBag)
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
        if let header = section.header, indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ViewAllHeaderCell.cellId,
                for: indexPath)
            cell.hideSeparator()
            (cell as? ViewAllHeaderCell)?.setup(title: header)
            (cell as? ViewAllHeaderCell)?.onActionTapped = {
                print("Tapped \(header)")
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TitledCell.cellId,
            for: indexPath)
        let row = section.data
        if !section.separator {
            cell.hideSeparator()
        }
        (cell as? TitledCell)?.setup(title: row.title ?? "N/A")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = viewModel.value.sections.elementIfExists(index: indexPath.section) else {
            assertionFailure("Failed to dequeue")
            return 0
        }
        if section.header != nil, indexPath.row == 0 {
            return 60
        }
        return 100
    }
}

extension UINavigationItem {
    func setTitle(_ title: String, subtitle: String) {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 17.0)
        titleLabel.textColor = .black

        let subtitleLabel = UILabel()
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 12.0)
        subtitleLabel.textColor = .gray

        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .vertical

        self.titleView = stackView
    }
}

final class TitledCell: UITableViewCell {
    public static let cellId = "TitledCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(in: contentView, padding: .init(horizontal: 16, vertical: 6))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String) {
        titleLabel.text = title
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
