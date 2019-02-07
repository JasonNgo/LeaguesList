//
//  LeaguesController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

/// LeaguesController manages a CollectionView of a list of leagues
final class LeaguesController: UIViewController {
    
    // MARK: - Coordinator
    weak var coordinator: LeaguesCoordinator?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 45
    private let minimumLineSpacingForSection: CGFloat = 1
    
    // MARK: - DataSource
    private let leaguesDataSource: LeaguesControllerDataSource
    
    // MARK: - UICollectionView
    private let reuseId = "LeagueCell"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - SearchController
    private let leaguesSearchController = UISearchController(searchResultsController: nil)
    private var isSearching = false
    
    init(leaguesDataSource: LeaguesControllerDataSource) {
        self.leaguesDataSource = leaguesDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Overrides
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        setupCollectionView()
        setupLeaguesSearchController()
        
        // Using completion handlers
        leaguesDataSource.fetchLeagues { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.collectionView.backgroundView = nil
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupController() {
        title = "Leagues"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = leaguesDataSource
        collectionView.register(LeagueCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.refreshControl = refreshControl
        collectionView.backgroundView = UIView.createEmptyStateView(with: collectionView.bounds)
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    private func setupLeaguesSearchController() {
        self.definesPresentationContext = true
        navigationItem.searchController = leaguesSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        leaguesSearchController.dimsBackgroundDuringPresentation = false
        leaguesSearchController.searchBar.delegate = self
        leaguesSearchController.searchBar.placeholder = "Search leagues by name or slug"
    }
    
    // MARK: - Target Actions
    
    @objc private func handleRefreshControl() {
        guard !isSearching else {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        // Using completion handlers
        leaguesDataSource.fetchLeagues { [weak self] error in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
            
            if let error = error {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.collectionView.backgroundView = nil
                let backgroundView = self.leaguesDataSource.backgroundView(with: self.collectionView.bounds)
                self.collectionView.backgroundView = backgroundView
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Search Controller

extension LeaguesController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearching = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCollectionResults(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterCollectionResults(with: "")
    }
    
    private func filterCollectionResults(with searchText: String) {
        collectionView.backgroundView = nil
        leaguesDataSource.filterResultsBy(searchText)
        collectionView.backgroundView = leaguesDataSource.backgroundView(with: collectionView.bounds)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension LeaguesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let league = leaguesDataSource.item(at: indexPath) else { return }
        coordinator?.leaguesControllerDidSelectItem(league)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LeaguesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
