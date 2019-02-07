//
//  LeaguesDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation
import PromiseKit

enum LeaguesDataManagerError: Error {
    case unableToFetchListOfLeagues(Error)
    case unableToDecodeListOfLeagues
}

/// Acts as a bridge between API and ViewControllerDataSources.
/// Interacts with TheScoreEndPoint to fetch data and performs the required data transformations to
/// League objects that the LeagueControllerDataSource can store and use.
final class LeaguesDataManager {
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    func fetchListOfLeagues(completion: @escaping (Result<[League], LeaguesDataManagerError>) -> Void) {
        fileAccessor.request(.leagues) { result in
            switch result {
            case .success(let data):
                do {
                    let leagues = try JSONDecoder().decode([Safe<League>].self, from: data)
                    let leaguesNoNil = leagues.compactMap { $0.value }
                    let sortedLeagues = leaguesNoNil.sorted { return $0.fullName < $1.fullName }
                    completion(.success(sortedLeagues))
                } catch {
                    completion(.failure(.unableToDecodeListOfLeagues))
                }
            case .failure(let error):
                completion(.failure(.unableToFetchListOfLeagues(error)))
            }
        }
    }
    
    func fetchListOfLeagues() -> Promise<[League]> {
        return firstly {
            fileAccessor.request(.leagues)
        }.compactMap {
            let leagues = try JSONDecoder().decode([Safe<League>].self, from: $0)
            let leaguesWithoutNil = leagues.compactMap { $0.value }
            let sortedLeagues = leaguesWithoutNil.sorted { $0.fullName < $1.fullName }
            return sortedLeagues
        }
    }
}
