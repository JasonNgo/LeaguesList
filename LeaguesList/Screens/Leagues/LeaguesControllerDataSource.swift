//
//  LeaguesControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

enum LeaguesControllerDataSourceError: Error {
    case noResults
    case error(Error)
}

final class LeaguesControllerDataSource: NSObject {
    private let leaguesDataManager: LeaguesDataManager
    
    private let reuseId = "LeagueCell"
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    
    init(leaguesDataManager: LeaguesDataManager) {
        self.leaguesDataManager = leaguesDataManager
        super.init()
    }
    
    func fetchLeagues(completion: @escaping (LeaguesControllerDataSourceError?) -> Void) {
        leaguesDataManager.fetchListOfLeagues { result in
            switch result {
            case .success(let leagues):
                guard !leagues.isEmpty else {
                    completion(LeaguesControllerDataSourceError.noResults)
                    return
                }
                
                self.leagues = leagues
                self.filteredLeagues = leagues
            case .failure(let error):
                completion(LeaguesControllerDataSourceError.error(error))
                return
            }
            
            completion(nil)
        }
    }
    
    // Using Promises
    @discardableResult
    func fetchLeagues() -> Promise<Void> {
        return leaguesDataManager.fetchListOfLeagues().done { leagues in
            self.leagues = leagues
            self.filteredLeagues = leagues
        }
    }
    
    func item(at indexPath: IndexPath) -> League? {
        guard !filteredLeagues.isEmpty else {
            return nil
        }
        
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
    
    func backgroundView(with rect: CGRect) -> UIView? {
        if leagues.isEmpty {
            return UIView.createEmptyStateView(with: rect)
        }

        if filteredLeagues.isEmpty {
            return UIView.createNoSearchResultsStateView(with: rect)
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
        let leagueCellViewModel = LeagueCellViewModel(league: league)
        cell.configureCell(using: leagueCellViewModel)
        
        return cell
    }
}
