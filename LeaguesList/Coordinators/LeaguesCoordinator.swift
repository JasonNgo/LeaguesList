//
//  LeaguesCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

protocol LeaguesCoordinatorDelegate: AnyObject {
    func leaguesCoordinatorDidDismiss(leaguesCoordinator: LeaguesCoordinator)
}

/// Coordinator in charge of handling navigations and dependencies associated with the LeaguesController.
final class LeaguesCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private let leaguesDataManager: LeaguesDataManager
    private let leaguesControllerDataSource: LeaguesControllerDataSource
    
    weak var delegate: LeaguesCoordinatorDelegate?
    
    init(navigationController: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        self.fileAccessor = fileAccessor
        self.leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        self.leaguesControllerDataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)
    }
    
    deinit {
        delegate?.leaguesCoordinatorDidDismiss(leaguesCoordinator: self)
    }
    
    func start() {
        let leaguesController = LeaguesController(leaguesDataSource: leaguesControllerDataSource)
        leaguesController.coordinator = self
        navigationController.pushViewController(leaguesController, animated: true)
    }
}

// MARK: - LeaguesControllerDelegate

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItem(_ league: League) {
        let teamsCoordinator = TeamsCoordinator(navigationController: navigationController, fileAccessor: fileAccessor, league: league)
        teamsCoordinator.delegate = self
        teamsCoordinator.start()
        add(childCoordinator: teamsCoordinator)
    }
}

// MARK: - TeamsCoordinatorDelegate

extension LeaguesCoordinator: TeamsCoordinatorDelegate {
    func teamsCoordinatorDidDismiss(teamsCoordinator: TeamsCoordinator) {
        remove(childCoordinator: teamsCoordinator)
    }
}
