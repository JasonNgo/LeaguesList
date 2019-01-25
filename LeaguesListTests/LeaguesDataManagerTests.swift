//
//  LeaguesDataManagerTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesDataManagerTests: XCTestCase {
    
    func testLeaguesDataManagerDataTransformation() {
        let fileAccessor = FileAccessor<TheScoreEndPoint>()
        let leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        let leagueFactory = LeaguesFactory()
        
        let expected = leagueFactory.leagues
        leaguesDataManager.fetchListOfLeagues()
        let actual = leaguesDataManager.leagues
        
        XCTAssert(expected == actual)
    }
    
    func testTeamsDataManagerNHLDataTransformation() {
        let fileAccessor = FileAccessor<TheScoreEndPoint>()
        let teamsDataManager = TeamsDataManager(fileAccessor: fileAccessor)
        let teamsFactory = TeamsFactory()
        let slug = "nhl"
        
        let expected = teamsFactory.teams
        
        teamsDataManager.getTeamsForSlug(slug) { (result) in
            switch result {
            case .success(let teams):
                XCTAssert(expected == teams)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
