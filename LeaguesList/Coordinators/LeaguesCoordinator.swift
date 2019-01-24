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
        let leagueViewModels = fetchLeagueViewModels()
        
        leaguesController.title = "Leagues"
        leaguesController.delegate = self
        leaguesController.leagueViewModels = leagueViewModels
        
        presenter.show(leaguesController, sender: self)
        self.leaguesController = leaguesController
    }
}

extension LeaguesCoordinator: LeaguesControllerDelegate {
    
    func leaguesControllerDidSelectItemAt(_ indexPath: IndexPath) {
        let selectedLeague = leaguesDataManager.getLeagueAt(indexPath.item)
        
        fetchTeamViewModels(for: selectedLeague.slug) { (teamViewModels) in
            let teamsController = TeamsController()
            teamsController.title = selectedLeague.fullName
            teamsController.delegate = self
            teamsController.slug = selectedLeague.slug
            teamsController.teamViewModels = teamViewModels
            
            self.presenter.show(teamsController, sender: self)
            
            self.teamsController = teamsController
        }
    }
    
    func leaguesControllerDidRefresh() {
        leaguesController?.leagueViewModels = fetchLeagueViewModels()
    }
    
}

extension LeaguesCoordinator: TeamsControllerDelegate {
    func teamsControllerDidRefresh(_ slug: String) {
        fetchTeamViewModels(for: slug) { (teamViewModels) in
            self.teamsController?.teamViewModels = teamViewModels
        }
    }
}

// MARK: - Fetching Helpers
private extension LeaguesCoordinator {
    
    private func fetchLeagueViewModels() -> [LeagueCellViewModel] {
        leaguesDataManager.fetchListOfLeagues()
        let leagues = leaguesDataManager.leagues
        let leagueViewModels = leagues.map { LeagueCellViewModel(league: $0) }
        
        return leagueViewModels
    }
    
    private func fetchTeamViewModels(for slug: String, completion: @escaping ([TeamCellViewModel]) -> Void) {
        teamsDataManager.getTeamsForSlug(slug) { (result) in
            switch result {
            case .success(let teams):
                let teamViewModels = teams.map { TeamCellViewModel(team: $0) }
                completion(teamViewModels)
            case .failure:
                completion([])
            }
        }
    }
    
}
