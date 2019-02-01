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
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    private let leaguesDataManager: LeaguesDataManager
    private let leaguesControllerDataSource: LeaguesControllerDataSource
    private var leaguesController: LeaguesController?
    
    private var teamsCoordinator: TeamsCoordinator?
    
    init(presenter: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.presenter = presenter
        self.fileAccessor = fileAccessor
        self.leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        self.leaguesControllerDataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)
    }
    
    func start() {
        let leaguesController = LeaguesController(leaguesDataSource: leaguesControllerDataSource)
        leaguesController.delegate = self
        
        self.presenter.pushViewController(leaguesController, animated: true)
        self.leaguesController = leaguesController
    }
}

// MARK: - LeaguesControllerDelegate

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItem(_ league: League) {
        let teamsCoordinator = TeamsCoordinator(presenter: presenter, fileAccessor: fileAccessor, league: league)
        teamsCoordinator.delegate = self
        self.teamsCoordinator = teamsCoordinator
        teamsCoordinator.start()
    }
}

// MARK: - TeamsCoordinatorDelegate

extension LeaguesCoordinator: TeamsCoordinatorDelegate {
    func teamsCoordinatorDidDismiss() {
        teamsCoordinator = nil
    }
}
