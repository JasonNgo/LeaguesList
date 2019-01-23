//
//  LeaguesCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class LeaguesCoordinator: Coordinator {
    private let presenter: UINavigationController
    
    private var leaguesController: LeaguesController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let leaguesController = LeaguesController()
        leaguesController.view.backgroundColor = .yellow
        leaguesController.title = "Leagues"
        presenter.show(leaguesController, sender: self)
    }
}
