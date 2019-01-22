//
//  ApplicationCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    
    let leaguesCoordinator: LeaguesCoordinator
    
    init(window: UIWindow) {
        self.window = window
        rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        
        leaguesCoordinator = LeaguesCoordinator(presenter: rootViewController)
    }
    
    func start() {
        window.rootViewController = rootViewController
        leaguesCoordinator.start()
        window.makeKeyAndVisible()
    }
}
