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
class ApplicationCoordinator: Coordinator {
    // MARK: Dependencies
    private let window: UIWindow
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    private let navigationController: UINavigationController
    private var leaguesCoordinator: LeaguesCoordinator?
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.navigationController.navigationBar.prefersLargeTitles = true
        self.fileAccessor = FileAccessor<TheScoreEndPoint>()
        super.init()
        
        window.rootViewController = navigationController
    }
    
    override func start() {
        showLeaguesList()
        window.makeKeyAndVisible()
    }
    
    func showLeaguesList() {
        leaguesCoordinator = LeaguesCoordinator(navigationController: navigationController, fileAccessor: fileAccessor)
        leaguesCoordinator?.start()
        leaguesCoordinator?.stop = { [weak self] in
            self?.leaguesCoordinator = nil
        }
    }
}
