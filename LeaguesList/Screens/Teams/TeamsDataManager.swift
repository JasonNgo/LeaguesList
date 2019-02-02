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
    case unableToFetchListOfTeams
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
    
    func getTeams() -> Promise<[Team]> {
        return firstly {
            fileAccessor.request(.teams(slug: league.slug))
            }.compactMap {
                let teams = try JSONDecoder().decode([Team].self, from: $0)
                let sortedTeams = teams.sorted { return $0.fullName < $1.fullName }
                return sortedTeams
        }
    }
}
