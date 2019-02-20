//
//  LeaguesCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// Coordinator in charge of handling navigations and dependencies associated with the LeaguesController.
class LeaguesCoordinator: Coordinator {
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<SportsEndPoint>
    private let leaguesDataManager: LeaguesDataManager
    private let leaguesControllerDataSource: LeaguesControllerDataSource
    
    private let navigationController: UINavigationController
    private var teamsCoordinator: TeamsCoordinator?
    
    init(navigationController: UINavigationController, fileAccessor: FileAccessor<SportsEndPoint>) {
        self.navigationController = navigationController
        self.fileAccessor = fileAccessor
        self.leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        self.leaguesControllerDataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)
    }
    
    override func start() {
        let leaguesController = LeaguesController(leaguesDataSource: leaguesControllerDataSource)
        leaguesController.didSelectItem = { [weak self] league in
            self?.createTeamsCoordinator(with: league)
        }
        
        setDeallocallable(with: leaguesController)
        navigationController.pushViewController(leaguesController, animated: true)
    }
    
    func createTeamsCoordinator(with league: League) {
        let teamsCoordinator = TeamsCoordinator(navigationController: navigationController, fileAccessor: fileAccessor, league: league)
        teamsCoordinator.start()
        teamsCoordinator.stop = { [weak self] in
            self?.teamsCoordinator = nil
        }
        
        self.teamsCoordinator = teamsCoordinator
    }
}

