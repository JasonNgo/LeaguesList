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
    private let rootViewController: UINavigationController
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    private let leaguesCoordinator: LeaguesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        fileAccessor = FileAccessor<TheScoreEndPoint>()

        leaguesCoordinator = LeaguesCoordinator(presenter: rootViewController, fileAccessor: fileAccessor)
    }
    
    func start() {
        window.rootViewController = rootViewController
        leaguesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
