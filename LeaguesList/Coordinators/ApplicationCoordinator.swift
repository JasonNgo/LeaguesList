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
final class ApplicationCoordinator: NSObject, Coordinator {
    private let window: UIWindow
    
    var parentCoordinator: Coordinator?
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator]
    
    // MARK: Dependencies
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.fileAccessor = FileAccessor<TheScoreEndPoint>()
        self.childCoordinators = []
        super.init()
        
        navigationController.delegate = self
        window.rootViewController = navigationController
    }
    
    func start() {
        showLeaguesList()
        window.makeKeyAndVisible()
    }
    
    func showLeaguesList() {
        let leaguesCoordinator = LeaguesCoordinator(navigationController: navigationController, fileAccessor: fileAccessor)
        leaguesCoordinator.parentCoordinator = self
        leaguesCoordinator.start()
        add(childCoordinator: leaguesCoordinator)
    }
}

// MARK: - UINavigationControllerDelegate

extension ApplicationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        // Read the view controller we’re moving from.
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        // Check whether our view controller array already contains that view controller. If it does it means we’re pushing a different view controller on top rather than popping it, so exit.
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let teamsController = fromViewController as? TeamsController {
            if let teamsCoordinator = teamsController.coordinator {
                teamsCoordinator.completed()
            }
        } else if let leaguesController = fromViewController as? LeaguesController {
            if let leaguesCoordinator = leaguesController.coordinator {
                leaguesCoordinator.completed()
            }
        }
    }
}
