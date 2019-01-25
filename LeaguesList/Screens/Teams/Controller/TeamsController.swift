//
//  TeamsController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

protocol TeamsControllerDelegate: class {
    func teamsControllerDidRefresh(_ slug: String)
}

final class TeamsController: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: TeamsControllerDelegate?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 60
    private let minimumLineSpacingForSection: CGFloat = 0
    private let emptyStateMessage = "No Data Found"
    private let emptyStateDescription = "\n\nPlease try loading the page\nagain at a later time"
    private let noSearchResultsString = "No results found"
    
    // MARK: - DataSource
    private var teamsDataSource: TeamsControllerDataSource
    
    // MARK: - UICollectionView
    
    private let reuseId = "TeamCell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(TeamCell.self, forCellWithReuseIdentifier: reuseId)
        cv.backgroundColor = .white
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        return rc
    }()
    
    // MARK: - SearchController
    
    private let teamsSearchController = UISearchController(searchResultsController: nil)
    private var filteredTeams: [Team] = []
    
    // MARK: - Model
    var teams: [Team] = [] {
        didSet {
            collectionView.refreshControl?.endRefreshing()
            filteredTeams = teams
            collectionView.reloadData()
        }
    }
    
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
        teamsDataSource.fetchTeamsForLeague()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
//        delegate?.teamsControllerDidRefresh(league.slug)
    }
}


// MARK: - UISearchBarDelegate

extension TeamsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredTeams = teams
        } else {
            filteredTeams = teams.filter({ (team) -> Bool in
                return
                    team.fullName.lowercased().contains(searchText.lowercased()) ||
                    team.name.lowercased().contains(searchText.lowercased()) ||
                    team.location?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
        
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
