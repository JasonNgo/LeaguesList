//
//  TeamsDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

enum TeamsDataManagerError: Error {
    case unableToFetchListOfTeams
    case unableToDecodeListOfTeams
}

typealias TeamsDataManagerCompletion = (Result<[Team], TeamsDataManagerError>) -> Void

final class TeamsDataManager {
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    private var teamsCache: [String: [Team]] = [:]
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    func getTeamsForSlug(_ slug: String, completion: @escaping TeamsDataManagerCompletion) {
        if let teams = teamsCache[slug] {
            completion(.success(teams))
            return
        }
        
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let teams = try JSONDecoder().decode([Team].self, from: data)
                    let sortedTeams = teams.sorted { return $0.fullName < $1.fullName }
                    self.teamsCache[slug] = sortedTeams
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
    
}
