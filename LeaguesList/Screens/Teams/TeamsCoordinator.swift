//
//  TeamsCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// Coordinator in charge of handling navigations and dependencies associated with the TeamsController.
final class TeamsCoordinator: Coordinator {
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private let teamsDataManager: TeamsDataManager
    private let teamsControllerDataSource: TeamsControllerDataSource
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>, league: League) {
        self.navigationController = navigationController
        self.fileAccessor = fileAccessor
        self.teamsDataManager = TeamsDataManager(league: league, fileAccessor: fileAccessor)
        self.teamsControllerDataSource = TeamsControllerDataSource(teamsDataManager: teamsDataManager)
    }
    
    override func start() {
        let teamsController = TeamsController(teamsDataSource: teamsControllerDataSource)
        setDeallocallable(with: teamsController)
        navigationController.pushViewController(teamsController, animated: true)
    }
}
