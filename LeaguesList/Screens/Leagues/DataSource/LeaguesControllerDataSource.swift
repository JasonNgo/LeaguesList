//
//  LeaguesControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class LeaguesControllerDataSource: NSObject, UICollectionViewDataSource {
    
    private let leaguesDataManager: LeaguesDataManager
    private let reuseId = "LeagueCell"
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(leaguesDataManager: LeaguesDataManager) {
        self.leaguesDataManager = leaguesDataManager
        super.init()
        
        leaguesDataManager.fetchListOfLeagues { result in
            switch result {
            case .success(let leagues):
                self.leagues = leagues
                self.filteredLeagues = leagues
            case .failure:
                self.leagues = []
                self.filteredLeagues = []
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLeagues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
            fatalError("Unable to dequeue cell")
        }
        
        cell.league = filteredLeagues[indexPath.item]
        return cell
    }
    
}

// MARK: - UICollectionViewDataSource

//extension LeaguesController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if leagues.count == 0 {
//            collectionView.setEmptyMessage(emptyStateMessage, description: emptyStateDescription)
//        } else {
//            if filteredLeages.count == 0 {
//                collectionView.setEmptyMessage("", description: noSearchResultsString)
//            } else {
//                collectionView.restore()
//            }
//        }
//
//        return filteredLeages.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
//            fatalError("Unable to dequeue League Cell")
//        }
//
//        cell.league = filteredLeages[indexPath.item]
//        return cell
//    }
//}
