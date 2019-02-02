//
//  LeaguesControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

final class LeaguesControllerDataSource: NSObject {
    private let leaguesDataManager: LeaguesDataManager
    private let leagueCellConfigurator: LeagueCellConfigurator
    
    private let reuseId = "LeagueCell"
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(leaguesDataManager: LeaguesDataManager) {
        self.leaguesDataManager = leaguesDataManager
        self.leagueCellConfigurator = LeagueCellConfigurator()
        super.init()
    }
    
    @discardableResult
    func fetchLeagues() -> Promise<Void> {
        return leaguesDataManager.fetchListOfLeagues().done { leagues in
            self.leagues = leagues
            self.filteredLeagues = leagues
        }
    }
    
    func item(at indexPath: IndexPath) -> League {
        return filteredLeagues[indexPath.item]
    }
    
    func filterResultsBy(_ searchText: String) {
        guard !searchText.isEmpty else {
            filteredLeagues = leagues
            return
        }
        
        let filterPredicate: (League) -> Bool = { league in
            league.fullName.lowercased().contains(searchText.lowercased()) ||
            league.slug.lowercased().contains(searchText.lowercased())
        }
        
        filteredLeagues = leagues.filter(filterPredicate)
    }
    
    func backgroundView(for collectionView: UICollectionView) -> UIView? {
        if leagues.count == 0 {
            return UIView.createEmptyStateView(for: collectionView)
        }
        
        if filteredLeagues.count == 0 {
            return UIView.createNoSearchResultsStateView(for: collectionView)
        }
        
        return nil
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
        
        let league = filteredLeagues[indexPath.item]
        leagueCellConfigurator.configure(cell: cell, with: league)
        
        return cell
    }
}
