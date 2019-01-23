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
        let leagueViewModels = leagues.map { $0.toLeagueCellViewModel() }
        
        leaguesController.title = "Leagues"
        leaguesController.leagueViewModels = leagueViewModels
        leaguesController.delegate = self
        
        presenter.show(leaguesController, sender: self)
    }
}

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItemAt(_ indexPath: IndexPath) {
        print(indexPath.item)
        let teamsController = TeamsController()
        teamsController.title = "Teams"
        presenter.show(teamsController, sender: self)
    }
}
