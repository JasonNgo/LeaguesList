//
//  TeamsControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

enum TeamsControllerDataSourceError: Error {
    case noResults
    case otherError(Error)
}

final class TeamsControllerDataSource: NSObject {
    private let teamsDataManager: TeamsDataManager
    
    private let reuseId = "TeamCell"
    private var teams: [Team] = []
    private var filteredTeams: [Team] = []
    
    var leagueTitle: String {
        return teamsDataManager.league.fullName
    }
    
    init(teamsDataManager: TeamsDataManager) {
        self.teamsDataManager = teamsDataManager
        super.init()
    }
    
    // Using completion handlers
    func fetchTeams(completion: @escaping (TeamsControllerDataSourceError?) -> Void) {
        teamsDataManager.getTeams { result in
            switch result {
            case .success(let teams):
                guard !teams.isEmpty else {
                    completion(TeamsControllerDataSourceError.noResults)
                    return
                }
                
                self.teams = teams
                self.filteredTeams = teams
            case .failure(let error):
                completion(TeamsControllerDataSourceError.otherError(error))
                return
            }
            
            completion(nil)
        }
    }
    
    // Using promises
    @discardableResult
    func fetchTeams() -> Promise<Void> {
        return teamsDataManager.getTeams().done { teams in
            self.teams = teams
            self.filteredTeams = teams
        }
    }
    
    func item(at indexPath: IndexPath) -> Team? {
        guard !filteredTeams.isEmpty else {
            return nil
        }
        
        return filteredTeams[indexPath.item]
    }
    
    func filterResultsBy(_ searchText: String) {
        guard !searchText.isEmpty else {
            filteredTeams = teams
            return
        }
        
        let filterPredicate: (Team) -> Bool = { team in
            team.fullName.lowercased().contains(searchText.lowercased()) ||
            team.name.lowercased().contains(searchText.lowercased()) ||
            team.location?.lowercased().contains(searchText.lowercased()) ?? false
        }
        
        filteredTeams = teams.filter(filterPredicate)
    }
    
    func backgroundView(with rect: CGRect) -> UIView? {
        if teams.count == 0 {
            return UIView.createEmptyStateView(with: rect)
        }
        
        if filteredTeams.count == 0 {
            return UIView.createNoSearchResultsStateView(with: rect)
        }
        
        return nil
    }
}

// MARK: - UICollectionViewDataSource

extension TeamsControllerDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredTeams.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? TeamCell else {
            fatalError("Unable to dequeue cell")
        }
        
        let team = filteredTeams[indexPath.item]
        let teamViewModel = TeamCellViewModel(team: team)
        cell.configureCell(using: teamViewModel)
        
        return cell
    }
}
