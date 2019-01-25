//
//  LeaguesController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// LeaguesController delegates responsibilities back to LeagueCoordinator
protocol LeaguesControllerDelegate: class {
    func leaguesControllerDidSelectItem(_ league: League)
    func leaguesControllerDidRefresh()
}

/// LeaguesController manages a CollectionView of a list of leagues
final class LeaguesController: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: LeaguesControllerDelegate?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 45
    private let minimumLineSpacingForSection: CGFloat = 1
    private let emptyStateMessage = "No Data Found"
    private let emptyStateDescription = "\n\nPlease try loading the page\nagain at a later time"
    private let noSearchResultsString = "No results found"
    
    // MARK: - UICollectionView
    private let reuseId = "LeagueCell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LeagueCell.self, forCellWithReuseIdentifier: reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return rc
    }()
    
    // MARK: - SearchController
    private let leaguesSearchController = UISearchController(searchResultsController: nil)
    private var filteredLeages: [League] = []
    
    // MARK: - Model
    var leagues: [League] = [] {
        didSet {
            collectionView.refreshControl?.endRefreshing()
            filteredLeages = leagues
            collectionView.reloadData()
        }
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
    }
    
    // MARK: - Setup
    
    private func setupController() {
        title = "Leagues"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
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
        delegate?.leaguesControllerDidRefresh()
    }
}

// MARK: - Search Controller

extension LeaguesController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredLeages = leagues
        } else {
            filteredLeages = leagues.filter({ (league) -> Bool in
                return
                    league.fullName.lowercased().contains(searchText.lowercased()) ||
                    league.slug.lowercased().contains(searchText.lowercased())  
            })
        }
        
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate

extension LeaguesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let league = filteredLeages[indexPath.item]
        delegate?.leaguesControllerDidSelectItem(league)
    }
}

// MARK: - UICollectionViewDataSource

extension LeaguesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if leagues.count == 0 {
            collectionView.setEmptyMessage(emptyStateMessage, description: emptyStateDescription)
        } else {
            if filteredLeages.count == 0 {
                collectionView.setEmptyMessage("", description: noSearchResultsString)
            } else {
                collectionView.restore()
            }
        }
        
        return filteredLeages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
            fatalError("Unable to dequeue League Cell")
        }
        
        cell.league = filteredLeages[indexPath.item]
        return cell
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
