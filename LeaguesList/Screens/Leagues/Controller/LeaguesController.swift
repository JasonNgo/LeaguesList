//
//  LeaguesController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// LeaguesController delegates responsibilities of didSelectItem back to LeagueCoordinator
protocol LeaguesControllerDelegate: class {
    func leaguesControllerDidSelectItemAt(_ indexPath: IndexPath)
    func leaguesControllerDidRefresh()
}

/// LeaguesController manages a CollectionView of a list of leagues
final class LeaguesController: UIViewController {
    
    // MARK: - Delegate
    weak var delegate: LeaguesControllerDelegate?
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 50
    private let minimumLineSpacingForSection: CGFloat = 5
    
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
    
    // MARK: - ViewModel
    var leagueViewModels: [LeagueCellViewModel] = [] {
        didSet {
            collectionView.refreshControl?.endRefreshing()
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
    }
    
    // MARK: - Target Actions
    
    @objc private func handleRefreshControl() {
        collectionView.refreshControl?.endRefreshing()
        delegate?.leaguesControllerDidRefresh()
    }
}

// MARK: - UICollectionViewDelegate

extension LeaguesController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.leaguesControllerDidSelectItemAt(indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension LeaguesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if leagueViewModels.count == 0 {
            collectionView.setEmptyMessage(
                "No data found",
                description: "\n\nPlease try loading the page\nagain at a later time"
            )
        } else {
            collectionView.restore()
        }
        
        return leagueViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
            fatalError("Unable to dequeue League Cell")
        }
        
        cell.leagueViewModel = leagueViewModels[indexPath.item]
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
