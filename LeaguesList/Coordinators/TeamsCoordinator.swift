//
//  TeamsCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

protocol TeamsCoordinatorDelegate: class {
    func teamsCoordinatorDidDismiss()
}

/// Coordinator in charge of handling navigations and dependencies associated with the TeamsController.
final class TeamsCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    private let league: League
    private let teamsDataManager: TeamsDataManager
    private let teamsControllerDataSource: TeamsControllerDataSource
    
    private var teamsController: TeamsController?
    
    weak var delegate: TeamsCoordinatorDelegate?
    
    init(presenter: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>, league: League) {
        self.presenter = presenter
        self.fileAccessor = fileAccessor
        self.league = league
        
        self.teamsDataManager = TeamsDataManager(fileAccessor: fileAccessor)
        self.teamsControllerDataSource = TeamsControllerDataSource(league: league, teamsDataManager: teamsDataManager)
    }
    
    func start() {
        let teamsController = TeamsController(teamsDataSource: teamsControllerDataSource)
        self.presenter.pushViewController(teamsController, animated: true)
        self.teamsController = teamsController
    }
}

extension TeamsCoordinator: TeamsControllerDelegate {
    func teamsControllerDidDismiss() {
        teamsController = nil
        delegate?.teamsCoordinatorDidDismiss()
    }
}
