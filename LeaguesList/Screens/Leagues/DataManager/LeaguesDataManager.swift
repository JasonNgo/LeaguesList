//
//  LeaguesDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

enum LeaguesDataManagerError: Error {
    case unableToFetchListOfLeagues(Error)
    case unableToDecodeListOfLeagues
}

/// Acts as a bridge between ViewControllers and the data associated with that controller.
/// Interacts with TheScoreEndPoint to fetch data and performs the required data transformations to
/// League objects that the LeagueController can interact with.
final class LeaguesDataManager {
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    var leagues: [League] = []
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    func fetchListOfLeagues(completion: @escaping (Result<[League], LeaguesDataManagerError>) -> Void) {
        fileAccessor.request(.leagues) { result in
            switch result {
            case .success(let data):
                do {
                    let leagues = try JSONDecoder().decode([League].self, from: data)
                    let sortedLeagues = leagues.sorted { return $0.fullName < $1.fullName }
                    self.leagues = sortedLeagues
                    completion(.success(sortedLeagues))
                } catch {
                    completion(.failure(LeaguesDataManagerError.unableToDecodeListOfLeagues))
                }
            case .failure(let error):
                completion(.failure(LeaguesDataManagerError.unableToFetchListOfLeagues(error)))
            }
        }
    }
}
