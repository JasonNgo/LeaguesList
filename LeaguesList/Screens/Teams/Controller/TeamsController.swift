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
    private let cellHeight: CGFloat = 50
    private let minimumLineSpacingForSection: CGFloat = 5
    
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
    
    // MARK: - ViewModel
    var teamViewModels: [TeamCellViewModel] = [] {
        didSet {
            collectionView.refreshControl?.endRefreshing()
            collectionView.reloadData()
        }
    }
    var slug: String?
    
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
        guard let slug = self.slug else { return }
        delegate?.teamsControllerDidRefresh(slug)
    }
}

extension TeamsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if teamViewModels.count == 0 {
            let message = "No Data Found"
            let description = "\n\nPlease try loading the page\nagain at a later time"
            collectionView.setEmptyMessage(message, description: description)
        } else {
            collectionView.restore()
        }
        
        return teamViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? TeamCell else {
            fatalError("Unable to dequeue Team Cell")
        }
        
        cell.teamCellViewModel = teamViewModels[indexPath.item]
        return cell
    }
}

extension TeamsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
