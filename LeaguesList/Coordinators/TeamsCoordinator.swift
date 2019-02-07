//
//  TeamsCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

protocol TeamsCoordinatorDelegate: class {
    func teamsCoordinatorDidDismiss(teamsCoordinator: TeamsCoordinator)
}

/// Coordinator in charge of handling navigations and dependencies associated with the TeamsController.
final class TeamsCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private let teamsDataManager: TeamsDataManager
    private let teamsControllerDataSource: TeamsControllerDataSource
    
    weak var delegate: TeamsCoordinatorDelegate?
    
    init(navigationController: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>, league: League) {
        self.navigationController = navigationController
        self.childCoordinators = []
        
        self.fileAccessor = fileAccessor
        self.teamsDataManager = TeamsDataManager(league: league, fileAccessor: fileAccessor)
        self.teamsControllerDataSource = TeamsControllerDataSource(teamsDataManager: teamsDataManager)
    }
    
    func start() {
        let teamsController = TeamsController(teamsDataSource: teamsControllerDataSource)
        teamsController.coordinator = self
        navigationController.pushViewController(teamsController, animated: true)
    }
}

extension TeamsCoordinator: TeamsControllerDelegate {
    func teamsControllerDidDismiss() {
        delegate?.teamsCoordinatorDidDismiss(teamsCoordinator: self)
    }
}
