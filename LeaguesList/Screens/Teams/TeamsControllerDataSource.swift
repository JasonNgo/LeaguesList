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
    private let reuseId = "TeamCell"
    private var teams: [Team] = []
    private var filteredTeams: [Team] = []
    
    var leagueTitle: String {
        return league.fullName
    }
    
    init(league: League, teamsDataManager: TeamsDataManager) {
        self.league = league
        self.teamsDataManager = teamsDataManager
        super.init()
    }
    
    @discardableResult
    func fetchTeams() -> Promise<Void> {
        return Promise { seal in
            teamsDataManager.getTeams().done { teams in
                self.teams = teams
                self.filteredTeams = teams
                seal.fulfill()
            }.catch { error in
                self.teams = []
                self.filteredTeams = []
                seal.reject(error)
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> Team {
        return filteredTeams[indexPath.item]
    }
    
    func filterResultsBy(_ searchText: String) {
        if searchText.isEmpty {
            filteredTeams = teams
        } else {
            filteredTeams = teams.filter({ team -> Bool in
                return
                    team.fullName.lowercased().contains(searchText.lowercased()) ||
                    team.name.lowercased().contains(searchText.lowercased()) ||
                    team.location?.lowercased().contains(searchText.lowercased()) ?? false
            })
        }
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
    
    //    func fetchTeamsForLeague() {
    //        teamsDataManager.getTeamsForSlug(league.slug) { result in
    //            switch result {
    //            case .success(let teams):
    //                self.teams = teams
    //                self.filteredTeams = teams
    //            case .failure:
    //                self.teams = []
    //                self.filteredTeams = []
    //            }
    //        }
    //    }

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
        
        cell.team = filteredTeams[indexPath.item]
        return cell
    }
}
