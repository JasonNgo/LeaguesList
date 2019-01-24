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
    private var imageCache: [String: Data] = [:]
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    func getImageDataForTeam(_ team: Team) -> Data? {
        guard let imageUrl = team.logoUrl else { return nil }
        return imageCache[imageUrl]
    }
    
    func getTeamsForSlug(_ slug: String, completion: @escaping TeamsDataManagerCompletion) {
        if let teams = teamsCache[slug] {
            teams.forEach { self.getImageForTeam($0) }
            completion(.success(teams))
            return
        }
        
        fileAccessor.request(.teams(slug: slug)) { (result) in
            switch result {
            case .success(let data):
                do {
                    let teams = try JSONDecoder().decode([Team].self, from: data)
                    teams.forEach { self.getImageForTeam($0) }
                    self.teamsCache[slug] = teams
                    completion(.success(teams))
                } catch {
                    completion(.failure(TeamsDataManagerError.unableToDecodeListOfTeams))
                    return
                }
            case .failure:
                completion(.failure(TeamsDataManagerError.unableToFetchListOfTeams))
            }
        }
    }
    
    private func getImageForTeam(_ team: Team) {
        guard let imageUrl = team.logoUrl else { return }
        guard let url = URL(string: imageUrl) else { return }
        let session = URLSession.init(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard 200...299 ~= httpResponse.statusCode else { return }
            guard let data = data else { return }
            if let _ = error { return }
            
            self.imageCache[imageUrl] = data
        }
        
        task.resume()
    }
    
}
