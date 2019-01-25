//
//  LeaguesCoordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// Coordinator in charge of handling navigations and dependencies associated with the LeaguesController.
final class LeaguesCoordinator: Coordinator {
    private let presenter: UINavigationController
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    private let leaguesDataManager: LeaguesDataManager
    private let leaguesControllerDataSource: LeaguesControllerDataSource
    private var leaguesController: LeaguesController?
    
    private var teamsCoordinator: TeamsCoordinator?
    
    init(presenter: UINavigationController, fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.presenter = presenter
        self.fileAccessor = fileAccessor
        self.leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        self.leaguesControllerDataSource = LeaguesControllerDataSource(leaguesDataManager: leaguesDataManager)
    }
    
    func start() {
        let leaguesController = LeaguesController(leaguesDataSource: leaguesControllerDataSource)
        leaguesController.delegate = self
        
        self.presenter.pushViewController(leaguesController, animated: true)
        self.leaguesController = leaguesController
    }
}

// MARK: - LeaguesControllerDelegate

extension LeaguesCoordinator: LeaguesControllerDelegate {
    func leaguesControllerDidSelectItem(_ league: League) {
        let teamsCoordinator = TeamsCoordinator(presenter: presenter, fileAccessor: fileAccessor, league: league)
        self.teamsCoordinator = teamsCoordinator
        teamsCoordinator.start()
        
        
        
//        fetchTeams(for: league.slug) { teams in
//            let teamsController = TeamsController(league: league)
//            teamsController.delegate = self
//            teamsController.teams = teams
//
//            self.presenter.pushViewController(teamsController, animated: true)
//            self.teamsController = teamsController
//        }
    }
}

// MARK: - TeamsControllerDelegate

extension LeaguesCoordinator: TeamsControllerDelegate {
    func teamsControllerDidRefresh(_ slug: String) {
//        fetchTeams(for: slug) { teams in
//            self.teamsController?.teams = teams
//        }
    }
}

// MARK: - Fetching Helpers

extension LeaguesCoordinator {
//    private func fetchTeams(for slug: String, completion: @escaping ([Team]) -> Void) {
//        teamsDataManager.getTeamsForSlug(slug) { result in
//            switch result {
//            case .success(let teams):
//                completion(teams)
//            case .failure:
//                completion([])
//            }
//        }
//    }
}
