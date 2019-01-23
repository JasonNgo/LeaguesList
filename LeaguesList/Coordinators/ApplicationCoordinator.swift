//
//  ApplicationCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// ApplicationCoordinator is represents the initial Coordinator that instantiates all the dependencies required by
/// the project. It uses dependency injection to insert the required dependencies to other coordinators.
final class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let fileAccessor: FileAccessor<TheScoreEndPoint>
    let leaguesDataManager: LeaguesDataManager
    let teamsDataManager: TeamsDataManager
    
    let leaguesCoordinator: LeaguesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
        fileAccessor = FileAccessor<TheScoreEndPoint>()
        leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        teamsDataManager = TeamsDataManager(fileAccessor: fileAccessor)
        
        leaguesCoordinator = LeaguesCoordinator(presenter: rootViewController, leaguesDataManager: leaguesDataManager, teamsDataManager: teamsDataManager)
    }
    
    func start() {
        window.rootViewController = rootViewController
        leaguesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
