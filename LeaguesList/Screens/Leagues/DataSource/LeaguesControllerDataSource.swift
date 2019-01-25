//
//  LeaguesControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class LeaguesControllerDataSource: NSObject {
    private let leaguesDataManager: LeaguesDataManager
    private let reuseId = "LeagueCell"
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(leaguesDataManager: LeaguesDataManager) {
        self.leaguesDataManager = leaguesDataManager
        super.init()
        refreshLeagueItems()
    }
    
    func refreshLeagueItems() {
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
    
    func item(at indexPath: IndexPath) -> League {
        return filteredLeagues[indexPath.item]
    }
    
    func filterResultsBy(_ searchText: String) {
        if searchText.isEmpty {
            filteredLeagues = leagues
        } else {
            filteredLeagues = leagues.filter({ league -> Bool in
                return
                    league.fullName.lowercased().contains(searchText.lowercased()) ||
                    league.slug.lowercased().contains(searchText.lowercased())
            })
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LeaguesControllerDataSource: UICollectionViewDataSource {
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
