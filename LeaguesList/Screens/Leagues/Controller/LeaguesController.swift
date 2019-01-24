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
    
    // MARK: - ViewModel
    var leagueViewModels: [LeagueCellViewModel] = []
    
    // MARK: - Overrides
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
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
