//
//  ViewController.swift
//  fetch-seat-geek
//
//  Created by Dan Draiman on 6/15/21.
//

import UIKit

final class ViewController: UIViewController {
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        searchController.searchBar.scopeButtonTitles = ["1", "2", "3"]
//                                                        Product.productTypeName(forType: .birthdays),
//                                                        Product.productTypeName(forType: .weddings),
//                                                        Product.productTypeName(forType: .funerals)]
        return searchController
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        navigationItem.searchController = searchController
        // Make the search bar always visible.
//        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //Send to VM
        //searchController.searchBar.text
        print("CHANGED")
    }
}

extension ViewController: UISearchBarDelegate {
    
}

extension ViewController: UISearchControllerDelegate {
    
}

