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
        
        let expected = [
            League(fullName: "NHL Hockey", slug: "nhl"),
            League(fullName: "NFL Football", slug: "nfl"),
            League(fullName: "MLB Baseball", slug: "mlb"),
            League(fullName: "NBA Basketball", slug: "nba"),
            League(fullName: "NCAA Football", slug: "ncaaf"),
            League(fullName: "World Junior Hockey Championship", slug: "wjhc"),
            League(fullName: "CFL Football", slug: "cfl"),
            League(fullName: "NCAA Women's Basketball", slug: "wcbk"),
            League(fullName: "NCAA Men's Basketball", slug: "ncaab"),
            League(fullName: "WNBA Basketball", slug: "wnba"),
            League(fullName: "EPL Soccer", slug: "epl"),
            League(fullName: "English Championship", slug: "engch"),
            League(fullName: "League Cup", slug: "engcc"),
            League(fullName: "FA Cup", slug: "engfa"),
            League(fullName: "UEFA Champions League", slug: "chlg"),
            League(fullName: "UEFA Europa League", slug: "uefa"),
            League(fullName: "Nations League A", slug: "natleaguea"),
            League(fullName: "Nations League B", slug: "natleagueb"),
            League(fullName: "Nations League C", slug: "natleaguec"),
            League(fullName: "Nations League D", slug: "natleagued"),
            League(fullName: "MLS Soccer", slug: "mls")
        ]
        
        let actual = leaguesDataManager.getListOfLeagues()
        XCTAssert(expected == actual)
    }
    
    func testTeamsDataManagerNHLDataTransformation() {
        let fileAccessor = FileAccessor<TheScoreEndPoint>()
        let teamsDataManager = TeamsDataManager()
        
        
    }
}
