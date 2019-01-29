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
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    func getTeamsForSlug(_ slug: String, completion: @escaping (Result<[Team], TeamsDataManagerError>) -> Void) {
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let teams = try JSONDecoder().decode([Team].self, from: data)
                    let sortedTeams = teams.sorted { return $0.fullName < $1.fullName }
                    completion(.success(sortedTeams))
                } catch {
                    completion(.failure(TeamsDataManagerError.unableToDecodeListOfTeams))
                    return
                }
            case .failure:
                completion(.failure(TeamsDataManagerError.unableToFetchListOfTeams))
            }
        }
    }
    
    func getTeamsForSlug(_ slug: String) -> Promise<[Team]> {
        return firstly {
            fileAccessor.request(.teams(slug: slug))
        }.compactMap {
            let teams = try JSONDecoder().decode([Team].self, from: $0)
            let sortedTeams = teams.sorted { return $0.fullName < $1.fullName }
            return sortedTeams
        }
    }
}
