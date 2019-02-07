//
//  TeamsController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

protocol TeamsControllerDelegate: class {
    func teamsControllerDidDismiss()
}

final class TeamsController: UIViewController {
    
    // MARK: - Coordinator
    var coordinator: TeamsCoordinator?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 60
    private let minimumLineSpacingForSection: CGFloat = 0
    
    // MARK: - DataSource
    private let teamsDataSource: TeamsControllerDataSource
    
    // MARK: - UICollectionView
    private let reuseId = "TeamCell"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: - SearchController
    private let teamsSearchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    
    // MARK: - Initializer
    
    init(teamsDataSource: TeamsControllerDataSource) {
        self.teamsDataSource = teamsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        setupTeamsSearchController()
        
        // Using completion handlers
        teamsDataSource.fetchTeams { [weak self] error in
            guard let self = self else { return }

            if let error = error {
                // There was an error, show an error message
                print(error)
                return
            }

            DispatchQueue.main.async {
                self.collectionView.backgroundView = nil
                self.collectionView.reloadData()
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        coordinator?.teamsControllerDidDismiss()
    }
    
    // MARK: - Setup
    
    private func setupController() {
        title = teamsDataSource.leagueTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = teamsDataSource
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.backgroundView = UIView.createEmptyStateView(with: collectionView.bounds)
        
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupTeamsSearchController() {
        self.definesPresentationContext = true
        navigationItem.searchController = teamsSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        teamsSearchController.dimsBackgroundDuringPresentation = false
        teamsSearchController.searchBar.delegate = self
        teamsSearchController.searchBar.placeholder = "Search by name or location"
    }
    
    // MARK: - Target Actions
    
    @objc private func handleRefreshControl() {
        guard !isSearching else {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        // Using completion handlers
        teamsDataSource.fetchTeams { [weak self] error in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
            
            if let error = error {
                // There was an error, show an error message
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                self.collectionView.backgroundView = nil
                let backgroundView = self.teamsDataSource.backgroundView(with: self.collectionView.bounds)
                self.collectionView.backgroundView = backgroundView
                self.collectionView.reloadData()
            }
        }
        
        // Using Promises
//        teamsDataSource.fetchTeams().done(on: DispatchQueue.main, flags: nil) { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.reloadData()
//        }.ensure { [weak self] in
//            guard let self = self else { return }
//            self.collectionView.backgroundView = nil
//            let backgroundView = self.teamsDataSource.backgroundView(for: self.collectionView)
//            self.collectionView.backgroundView = backgroundView
//            self.collectionView.refreshControl?.endRefreshing()
//        }.catch { [weak self] error in
//            guard let self = self else { return }
//            print("Error fetching teams: \(error.localizedDescription)")
//        }
    }
}


// MARK: - UISearchBarDelegate

extension TeamsController: UISearchBarDelegate {
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
        teamsDataSource.filterResultsBy(searchText)
        collectionView.backgroundView = teamsDataSource.backgroundView(with: collectionView.bounds)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TeamsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
