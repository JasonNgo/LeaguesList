//
//  LeaguesDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

class LeaguesDataManager {
    private var fileAccessor: FileAccessor<TheScoreEndPoint>
    private (set) var leagues: [League] = []
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
        
        fileAccessor.request(.leagues) { (result) in
            switch result {
            case .success(let data):
                do {
                    self.leagues = try JSONDecoder().decode([League].self, from: data)
                } catch {
                    print("Failure attempting to decode list of leagues")
                }
            case .failure(let error):
                print("Failure attempting to fetch list of leagues \(error.localizedDescription)")
            }
        }
    }
    
    func getListOfLeagues() -> [League] {
        return leagues
    }
}
