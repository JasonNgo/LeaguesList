//
//  TeamsControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class TeamsControllerDataSource: NSObject {
    private let league: League
    private let teamsDataManager: TeamsDataManager
    private let reuseId = "TeamCell"
    private var teams: [Team] = []
    private var filteredTeams: [Team] = []
    
    var leagueTitle: String {
        return league.fullName
    }
    
    private let emptyStateMessage = "No Data Found"
    private let emptyStateDescription = "\n\nPlease try loading the page\nagain at a later time"
    private let noSearchResultsString = "No results found"
    
    init(league: League, teamsDataManager: TeamsDataManager) {
        self.league = league
        self.teamsDataManager = teamsDataManager
        super.init()
    }
    
    func fetchTeamsForLeague() {
        teamsDataManager.getTeamsForSlug(league.slug) { result in
            switch result {
            case .success(let teams):
                self.teams = teams
                self.filteredTeams = teams
            case .failure:
                self.teams = []
                self.filteredTeams = []
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> Team {
        return filteredTeams[indexPath.item]
    }
}

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

//func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//    if teams.count == 0 {
//        collectionView.setEmptyMessage(emptyStateMessage, description: emptyStateDescription)
//    } else {
//        if filteredTeams.count == 0 {
//            collectionView.setEmptyMessage("", description: noSearchResultsString)
//        } else {
//            collectionView.restore()
//        }
//    }
//
//    return filteredTeams.count
//}
