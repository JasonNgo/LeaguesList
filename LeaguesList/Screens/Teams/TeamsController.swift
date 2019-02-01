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
    
    weak var delegate: TeamsControllerDelegate?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 60
    private let minimumLineSpacingForSection: CGFloat = 0
    
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
        
        teamsDataSource.fetchTeams().catch { error in
            print("Error fetching teams: \(error.localizedDescription)")
        }.finally { [weak self] in
            guard let self = self else { return }
            self.collectionView.backgroundView = nil
            let backgroundView = self.teamsDataSource.backgroundView(for: self.collectionView)
            self.collectionView.backgroundView = backgroundView
            self.collectionView.reloadData()
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        delegate?.teamsControllerDidDismiss()
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
        collectionView.backgroundView = UIView.createEmptyStateView(for: collectionView)
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
        teamsDataSource.fetchTeams().catch { error in
            print("Error fetching teams data: \(error.localizedDescription)")
        }.finally { [weak self] in
            guard let self = self else { return }
            self.collectionView.refreshControl?.endRefreshing()
            self.collectionView.backgroundView = nil
            
            let backgroundView = self.teamsDataSource.backgroundView(for: self.collectionView)
            self.collectionView.backgroundView = backgroundView
            self.collectionView.reloadData()
            
        }
    }
}


// MARK: - UISearchBarDelegate

extension TeamsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        collectionView.backgroundView = nil
        teamsDataSource.filterResultsBy(searchText)
        collectionView.backgroundView = teamsDataSource.backgroundView(for: collectionView)
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