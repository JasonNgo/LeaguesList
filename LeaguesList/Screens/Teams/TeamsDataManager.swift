//
//  TeamsDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation
import PromiseKit

enum TeamsDataManagerError: Error {
    case unableToFetchListOfTeams(Error)
    case unableToDecodeListOfTeams
}

/// Interacts with TheScoreAPI to provide data for the TeamsControllerDataSource.
/// Fetches the data and transforms it into Team models.
final class TeamsDataManager {
    private let league: League
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(league: League, fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.league = league
        self.fileAccessor = fileAccessor
    }
    
    // Using completion handlers
    func getTeams(completion: @escaping (Result<[Team], TeamsDataManagerError>) -> Void) {
        fileAccessor.request(.teams(slug: league.slug)) { result in
            switch result {
            case .success(let data):
                do {
                    let teams = try JSONDecoder().decode([Safe<Team>].self, from: data)
                    let teamsWithoutNil = teams.compactMap { $0.value }
                    let sortedTeams = teamsWithoutNil.sorted { $0.fullName < $1.fullName }
                    completion(.success(sortedTeams))
                } catch {
                    completion(.failure(TeamsDataManagerError.unableToDecodeListOfTeams))
                }
            case .failure(let error):
                completion(.failure(TeamsDataManagerError.unableToFetchListOfTeams(error)))
            }
        }
    }
    
    // using Promises
    func getTeams() -> Promise<[Team]> {
        return firstly {
            fileAccessor.request(.teams(slug: league.slug))
        }.compactMap {
            let teams = try JSONDecoder().decode([Safe<Team>].self, from: $0)
            let teamsWithoutNil = teams.compactMap { $0.value }
            let sortedTeams = teamsWithoutNil.sorted { return $0.fullName < $1.fullName }
            return sortedTeams
        }
    }
}
