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
    private let window: UIWindow
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.childCoordinators = []
        self.fileAccessor = FileAccessor<TheScoreEndPoint>()
        
        window.rootViewController = navigationController
    }
    
    func start() {
        showLeaguesList()
        window.makeKeyAndVisible()
    }
    
    func showLeaguesList() {
        let leaguesCoordinator = LeaguesCoordinator(navigationController: navigationController, fileAccessor: fileAccessor)
        leaguesCoordinator.delegate = self
        leaguesCoordinator.start()
        add(childCoordinator: leaguesCoordinator)
    }
}

extension ApplicationCoordinator: LeaguesCoordinatorDelegate {
    func leaguesCoordinatorDidDismiss(leaguesCoordinator: LeaguesCoordinator) {
        remove(childCoordinator: leaguesCoordinator)
    }
}
