//
//  LeaguesCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// Coordinator in charge of handling navigations and dependencies associated with the LeaguesController.
final class LeaguesCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let leaguesDataManager: LeaguesDataManager
    private let teamsDataManager: TeamsDataManager
    
    private var leaguesController: LeaguesController?
    private var teamsController: TeamsController?
    
    init(presenter: UINavigationController, leaguesDataManager: LeaguesDataManager, teamsDataManager: TeamsDataManager) {
        self.presenter = presenter
        self.leaguesDataManager = leaguesDataManager
        self.teamsDataManager = teamsDataManager
    }
    
    func start() {
        let leaguesController = LeaguesController()
        let leagues = fetchLeagues()
        
        leaguesController.title = "Leagues"
        leaguesController.delegate = self
        leaguesController.leagues = leagues
        
        presenter.show(leaguesController, sender: self)
        self.leaguesController = leaguesController
    }
}

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItemAt(_ indexPath: IndexPath) {
        let selectedLeague = leaguesDataManager.getLeagueAt(indexPath.item)
        
        fetchTeams(for: selectedLeague.slug) { (teams) in
            let teamsController = TeamsController()
            teamsController.title = selectedLeague.fullName
            teamsController.delegate = self
            teamsController.slug = selectedLeague.slug
            teamsController.teams = teams
            
            self.presenter.show(teamsController, sender: self)
            
            self.teamsController = teamsController
        }
    }
    
    func leaguesControllerDidRefresh() {
        leaguesController?.leagues = fetchLeagues()
    }
}

extension LeaguesCoordinator: TeamsControllerDelegate {
    func teamsControllerDidRefresh(_ slug: String) {
        fetchTeams(for: slug) { (teams) in
            self.teamsController?.teams = teams
        }
    }
}

// MARK: - Fetching Helpers
private extension LeaguesCoordinator {
    func fetchLeagues() -> [League] {
        leaguesDataManager.fetchListOfLeagues()
        let leagues = leaguesDataManager.leagues
        
        return leagues
    }
    
    func fetchTeams(for slug: String, completion: @escaping ([Team]) -> Void) {
        teamsDataManager.getTeamsForSlug(slug) { (result) in
            switch result {
            case .success(let teams):
                completion(teams)
            case .failure:
                completion([])
            }
        }
    }
}
