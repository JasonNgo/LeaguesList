//
//  LeaguesController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit
import JGProgressHUD

protocol LeaguesControllerDelegate: AnyObject {
    func leaguesControllerDidSelectItem(_ league: League)
}

private enum LeaguesControllerState {
    case loading
    case populated
    case empty
    case error(Error)
}

/// LeaguesController manages a CollectionView of a list of leagues
final class LeaguesController: UIViewController {
    weak var coordinator: (Coordinator & LeaguesControllerDelegate)?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 45
    private let minimumLineSpacingForSection: CGFloat = 1
    
    // MARK: - UICollectionView
    private let dataSource: LeaguesControllerDataSource
    private let reuseId = "LeagueCell"
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        return cv
    }()
    
    private let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.tintColor = .clear
        return rc
    }()
    
    private let progressHUD: JGProgressHUD = {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading leagues"
        return hud
    }()
    
    // MARK: - SearchController
    private let searchController = UISearchController(searchResultsController: nil)
    private var isSearching = false
    
    // MARK: - State
    private var state: LeaguesControllerState {
        didSet {
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                    self.collectionView.backgroundView = nil
                    self.progressHUD.show(in: self.view)
                }
                break
            case .populated:
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = nil
                    self.progressHUD.dismiss()
                    
                    let backgroundView = self.dataSource.backgroundView(with: self.collectionView.bounds)
                    self.collectionView.backgroundView = backgroundView
                    self.collectionView.reloadData()
                }
                break
            case .empty:
                DispatchQueue.main.async {
                    self.progressHUD.dismiss()
                    let backgroundView = self.dataSource.backgroundView(with: self.collectionView.bounds)
                    self.collectionView.backgroundView = backgroundView
                }
                break
            case .error(let error):
                DispatchQueue.main.async {
                    self.progressHUD.dismiss()
                    self.collectionView.backgroundView = nil
                    self.showErrorMessage(with: error)
                }
            }
        }
    }
    
    // MARK: Initializer
    
    init(leaguesDataSource: LeaguesControllerDataSource) {
        self.dataSource = leaguesDataSource
        self.state = .empty
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
        
        loadLeagueItems()
    }
    
    // MARK: - Setup
    
    private func setupController() {
        title = "Leagues"
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(LeagueCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        refreshControl.layer.isHidden = true
    }
    
    private func setupLeaguesSearchController() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search leagues by name or slug"
    }
    
    private func loadLeagueItems() {
        state = .loading
        dataSource.fetchLeagues { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                switch error {
                case LeaguesControllerDataSourceError.noResults:
                    self.state = .empty
                    return
                case LeaguesControllerDataSourceError.error(let error):
                    self.state = .error(error)
                    print(error)
                    return
                }
            }
            
            self.state = .populated
        }
    }
    
    // MARK: - Target Actions
    
    @objc private func handleRefreshControl() {
        guard !isSearching else {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        loadLeagueItems()
    }
    
    // MARK: - Helpers
    
    private func showErrorMessage(with error: Error) {
        let alertController = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
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
        self.dataSource.filterResultsBy(searchText)
        self.state = .populated
    }
}

// MARK: - UICollectionViewDelegate

extension LeaguesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let league = dataSource.item(at: indexPath) else { return }
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
