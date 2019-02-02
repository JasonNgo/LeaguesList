//
//  TeamsControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import PromiseKit

final class TeamsControllerDataSource: NSObject {
    private let league: League
    private let teamsDataManager: TeamsDataManager
    private let teamCellConfigurator: TeamCellConfigurator
    
    private let reuseId = "TeamCell"
    private var teams: [Team] = []
    private var filteredTeams: [Team] = []
    
    var leagueTitle: String {
        return league.fullName
    }
    
    init(league: League, teamsDataManager: TeamsDataManager) {
        self.league = league
        self.teamsDataManager = teamsDataManager
        self.teamCellConfigurator = TeamCellConfigurator()
        super.init()
    }
    
    @discardableResult
    func fetchTeams() -> Promise<Void> {
        return teamsDataManager.getTeams().done { teams in
            self.teams = teams
            self.filteredTeams = teams
        }
    }
    
    func item(at indexPath: IndexPath) -> Team {
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
    
    func backgroundView(for collectionView: UICollectionView) -> UIView? {
        if teams.count == 0 {
            return UIView.createEmptyStateView(for: collectionView)
        }
        
        if filteredTeams.count == 0 {
            return UIView.createNoSearchResultsStateView(for: collectionView)
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
        teamCellConfigurator.configure(cell: cell, with: team)
        
        return cell
    }
}
