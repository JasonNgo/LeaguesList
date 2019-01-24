//
//  LeaguesDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

/// Acts as a bridge between ViewControllers and the data associated with that controller.
/// Interacts with TheScoreEndPoint to fetch data and performs the required data transformations to
/// League objects that the LeagueController can interact with.
final class LeaguesDataManager {
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    var leagues: [League] = []
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
        fetchListOfLeagues()
    }
    
    func fetchListOfLeagues() {
        fileAccessor.request(.leagues) { (result) in
            switch result {
            case .success(let data):
                do {
                    let leagues = try JSONDecoder().decode([League].self, from: data)
                    let sortedLeagues = leagues.sorted { return $0.fullName < $1.fullName }
                    self.leagues = sortedLeagues
                } catch {
                    print("Failure attempting to decode list of leagues")
                    self.leagues = []
                }
            case .failure(let error):
                print("Failure attempting to fetch list of leagues \(error.localizedDescription)")
            }
        }
    }
    
    func getLeagueAt(_ index: Int) -> League {
        return leagues[index]
    }
}
