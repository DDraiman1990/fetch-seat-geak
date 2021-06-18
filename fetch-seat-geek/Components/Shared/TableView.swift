////
////  TableView.swift
////  fetch-seat-geek
////
////  Created by Dan Draiman on 6/16/21.
////
//
//import Foundation
//import Combine
//import UIKit
//
//class DiffableTableView<SectionModel: Hashable, RowModel: Hashable>: UIView, UITableViewDelegate {
//    
//    // MARK: - Internal Types
//    
//    struct DiffableCellRegistration {
//        var reuseId: String
//        var type: CellType
//        
//        enum CellType {
//            case fromNib(nib: UINib?)
//            case fromClass(type: AnyClass)
//        }
//    }
//    
//    struct DiffableSectionData {
//        var model: SectionModel
//        var rows: [RowModel]
//    }
//    
//    typealias CellTypeForModel = (RowModel) -> DiffableCellRegistration
//    typealias CellDequeue = (UITableViewCell, IndexPath, RowModel) -> UITableViewCell
//    typealias HeightForRow = ((RowModel, IndexPath) -> CGFloat)
//    typealias DidSelectRow = ((RowModel, IndexPath) -> Void)
//    typealias ActionsForRow = ((RowModel, IndexPath) -> [UIContextualAction])
//    typealias RefreshRequest = ((@escaping () -> Void) -> Void)
//    
//    // MARK: - Callbacks
//    
//    private var cellTypeForModel: CellTypeForModel
//    private var onDequeueCell: CellDequeue
//    var canEditRows: Bool {
//        get {
//            datasource.canEditRows
//        }
//        set {
//            datasource.canEditRows = newValue
//        }
//    }
//    var heightForRow: HeightForRow?
//    var didSelectRow: DidSelectRow?
//    var trailingSwipeActionsForRow: ActionsForRow?
//    var leadingSwipeActionsForRow: ActionsForRow?
//    var onRefreshRequested: RefreshRequest? {
//        didSet {
//            refreshControl = onRefreshRequested != nil ? .init() : nil
//            refreshControl?.addTarget(self, action: #selector(refreshRequested), for: .valueChanged)
//            table.refreshControl = refreshControl
//        }
//    }
//    
//    // MARK: - Properties | Private
//    override var backgroundColor: UIColor? {
//        get {
//            return table.backgroundColor
//        }
//        set {
//            table.backgroundColor = newValue
//        }
//    }
//    
//    var bounces: Bool {
//        get {
//            table.bounces
//        }
//        set {
//            table.bounces = newValue
//        }
//    }
//    private var subscriptions = Set<AnyCancellable>()
//    private var refreshControl: UIRefreshControl?
//    private var registeredCells: Set<String> = []
//    private let inverted: Bool
//    
//    // MARK: - Properties | Public
//    
//    @Published var snapshot: [DiffableSectionData] = []
//    
//    // MARK: - UI Components
//    
//    private lazy var datasource = EditableUITableViewDatasource<SectionModel, RowModel>(tableView: table) { [weak self] tableView, indexPath, rowModel in
//        return self?.dequeueCell(tableView: tableView,
//                                 indexPath: indexPath,
//                                 rowModel: rowModel)
//    }
//    
//    private lazy var table: UITableView = {
//        let table = UITableView()
//        table.delegate = self
//        table.backgroundView = EmptyListBackground(title: "This list is empty", body: "You don't have any content yet.", image: UIImage(systemName: "table", withConfiguration: UIImage.SymbolConfiguration(weight: .regular)))
//        return table
//    }()
//    
//    // MARK: - Lifecycle
//    
//    init(inverted: Bool = false,
//         cellTypeForModel: @escaping CellTypeForModel,
//         onDequeueCell: @escaping CellDequeue) {
//        self.inverted = inverted
//        self.cellTypeForModel = cellTypeForModel
//        self.onDequeueCell = onDequeueCell
//        super.init(frame: .zero)
//        if inverted {
//            table.transform = CGAffineTransform(scaleX: 1, y: -1)
//        }
//        table.automaticallyAdjustsScrollIndicatorInsets = false
//        addSubview(table)
//        table.anchor(in: self)
//        $snapshot
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] model in
//            self?.update(sections: model, animated: true)
//            self?.table.backgroundView?.isHidden = !model.isEmpty
//        }
//        .store(in: &subscriptions)
//        datasource.defaultRowAnimation = .fade
//        backgroundColor = .clear
//        table.tableFooterView = UIView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Private Helpers
//    
//    @objc private func refreshRequested() {
//        onRefreshRequested?({ [weak self] in
//            self?.refreshControl?.endRefreshing()
//        })
//    }
//    
//    private func dequeueCell(tableView: UITableView,
//                             indexPath: IndexPath,
//                             rowModel: RowModel) -> UITableViewCell {
//        let cellRegData = cellTypeForModel(rowModel)
//        registerIfNeeded(registration: cellRegData)
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellRegData.reuseId, for: indexPath)
//        if inverted {
//            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
//        }
//        return onDequeueCell(cell, indexPath, rowModel)
//    }
//    
//    private func registerIfNeeded(registration: DiffableCellRegistration) {
//        guard !registeredCells.contains(registration.reuseId) else {
//            return
//        }
//        switch registration.type {
//        case .fromClass(let type):
//            table.register(type, forCellReuseIdentifier: registration.reuseId)
//        case .fromNib(let nib):
//            table.register(nib, forCellReuseIdentifier: registration.reuseId)
//        }
//    }
//        
//    private func update(sections: [DiffableSectionData],
//                animated: Bool = false,
//                completion: (() -> Void)? = nil) {
//        var snapshot = NSDiffableDataSourceSnapshot<SectionModel, RowModel>()
//        sections.forEach {
//            snapshot.appendSections([$0.model])
//            snapshot.appendItems($0.rows, toSection: $0.model)
//        }
//        datasource.apply(snapshot, animatingDifferences: animated, completion: completion)
//    }
//    
//    // MARK: - Public API
//    
//    func set(emptyBackgroundView: UIView?) {
//        table.backgroundView = emptyBackgroundView
//    }
//    
//    func cellForRow(indexPath: IndexPath) -> UITableViewCell? {
//        return table.cellForRow(at: indexPath)
//    }
//    
//    func softReload() {
//        table.beginUpdates()
//        table.endUpdates()
//    }
//    
//    // MARK: - UITableViewDelegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let item = datasource.itemIdentifier(for: indexPath) else {
//            return
//        }
//        didSelectRow?(item, indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let item = datasource.itemIdentifier(for: indexPath) else {
//            return 0
//        }
//        return heightForRow?(item, indexPath) ?? UITableView.automaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard let item = datasource.itemIdentifier(for: indexPath),
//              let actions = leadingSwipeActionsForRow?(item, indexPath) else {
//            return nil
//        }
//        return .init(actions: actions)
//    }
//    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard let item = datasource.itemIdentifier(for: indexPath),
//              let actions = trailingSwipeActionsForRow?(item, indexPath) else {
//            return nil
//        }
//        return .init(actions: actions)
//    }
//}
