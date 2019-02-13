//
//  TeamsController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit
import JGProgressHUD

private enum TeamsControllerState {
    case loading
    case populated
    case empty
    case error(Error)
}

final class TeamsController: UIViewController, Deinitcallable {
    var onDeinit: (() -> Void)?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 60
    private let minimumLineSpacingForSection: CGFloat = 0
    
    // MARK: - UICollectionView
    private let dataSource: TeamsControllerDataSource
    private let reuseId = "TeamCell"
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
        hud.textLabel.text = "Loading Teams"
        return hud
    }()
    
    // MARK: - SearchController
    private let searchController = UISearchController(searchResultsController: nil)
    var isSearching: Bool = false
    
    private var state: TeamsControllerState = .empty {
        didSet {
            DispatchQueue.main.async {
                switch self.state {
                case .loading:
                    self.collectionView.refreshControl?.endRefreshing()
                    self.collectionView.backgroundView = nil
                    self.progressHUD.show(in: self.view)
                    
                    break
                case .populated:
                    self.progressHUD.dismiss()
                    let bounds = self.collectionView.bounds
                    let backgroundView = self.dataSource.backgroundView(with: bounds)
                    self.collectionView.backgroundView = backgroundView
                    
                    break
                case .empty:
                    self.progressHUD.dismiss()
                    let bounds = self.collectionView.bounds
                    let backgroundView = self.dataSource.backgroundView(with: bounds)
                    self.collectionView.backgroundView = backgroundView
                    
                    break
                case .error(let error):
                    self.progressHUD.dismiss()
                    self.collectionView.backgroundView = nil
                    self.showErrorMessage(with: error)
                }
            }
        }
    }
    
    deinit {
        onDeinit?()
    }
    
    // MARK: - Initializer
    
    init(teamsDataSource: TeamsControllerDataSource) {
        self.dataSource = teamsDataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: - Overrides
    
    override func willMove(toParent parent: UIViewController?) {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
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
        
        loadTeamItems()
    }
    
    private func loadTeamItems() {
        state = .loading
        dataSource.fetchTeams { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                switch error {
                case TeamsControllerDataSourceError.noResults:
                    self.state = .empty
                    return
                case TeamsControllerDataSourceError.otherError(let error):
                    self.state = .error(error)
                    print(error.localizedDescription)
                    return
                }
            }
            
            self.state = .populated
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupController() {
        title = dataSource.leagueTitle
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        collectionView.register(TeamCell.self, forCellWithReuseIdentifier: reuseId)
        collectionView.backgroundView = UIView.createEmptyStateView(with: collectionView.bounds)
        
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupTeamsSearchController() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by name or location"
    }
    
    // MARK: - Target Actions
    
    @objc private func handleRefreshControl() {
        guard !isSearching else {
            collectionView.refreshControl?.endRefreshing()
            return
        }
        
        loadTeamItems()
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
        dataSource.filterResultsBy(searchText)
        state = .populated
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
