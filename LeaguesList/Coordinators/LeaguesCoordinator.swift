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
        let leagues = leaguesDataManager.getListOfLeagues()
        let leagueViewModels = leagues.map { LeagueCellViewModel(league: $0) }
        
        leaguesController.title = "Leagues"
        leaguesController.leagueViewModels = leagueViewModels
        leaguesController.delegate = self
        
        presenter.show(leaguesController, sender: self)
    }
}

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItemAt(_ indexPath: IndexPath) {
        let selectedLeague = leaguesDataManager.getLeagueAt(indexPath.item)
        
        teamsDataManager.getTeamsForSlug(selectedLeague.slug) { (result) in
            switch result {
            case .success(let teams):
                var teamViewModels: [TeamCellViewModel] = []
                
                teams.forEach {
                    let imageData = self.teamsDataManager.getImageDataForTeam($0)
                    let viewModel = TeamCellViewModel(team: $0, imageData: imageData)
                    teamViewModels.append(viewModel)
                }
                
                let teamsController = TeamsController()
                teamsController.title = selectedLeague.fullName
                teamsController.teamViewModels = teamViewModels
                
                self.presenter.show(teamsController, sender: self)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
