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
    weak var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private let leaguesDataManager: LeaguesDataManager
    private let leaguesControllerDataSource: LeaguesControllerDataSource
    
    private var leaguesController: LeaguesController?
    
    init(navigationController: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        self.fileAccessor = fileAccessor
        self.leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        self.leaguesControllerDataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)
    }
    
    func start() {
        let leaguesController = LeaguesController(leaguesDataSource: leaguesControllerDataSource)
        leaguesController.coordinator = self
        navigationController.pushViewController(leaguesController, animated: true)
        self.leaguesController = leaguesController
    }
    
    func leaguesControllerDidSelectItem(_ league: League) {
        let teamsCoordinator = TeamsCoordinator(navigationController: navigationController, fileAccessor: fileAccessor, league: league)
        teamsCoordinator.parentCoordinator = self
        teamsCoordinator.start()
        add(childCoordinator: teamsCoordinator)
    }
}
