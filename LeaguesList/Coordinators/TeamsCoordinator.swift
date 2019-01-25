//
//  TeamsCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class TeamsCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private let league: League
    
    private let teamsDataManager: TeamsDataManager
    private let teamsControllerDataSource: TeamsControllerDataSource
    private var teamsController: TeamsController?
    
    init(presenter: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>, league: League) {
        self.presenter = presenter
        self.fileAccessor = fileAccessor
        self.league = league
        
        self.teamsDataManager = TeamsDataManager(fileAccessor: fileAccessor)
        self.teamsControllerDataSource = TeamsControllerDataSource(teamsDataManager: teamsDataManager)
    }
    
    func start() {
        print("Hello world")
    }
}
