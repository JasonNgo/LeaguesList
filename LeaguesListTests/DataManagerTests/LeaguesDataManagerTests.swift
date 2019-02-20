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
    let fileAccessor = FileAccessor<SportsEndPoint>()
    let leagueFactory = LeaguesFactory()
    
    func testFetchingListOfLeagues() {
        let leaguesDataManager = LeaguesDataManager(fileAccessor: fileAccessor)
        let expected = leagueFactory.leagues
        let expectation = self.expectation(description: "Data to League Transformation")
        
        var actualLeagues: [League] = []
        
        leaguesDataManager.fetchListOfLeagues { result in
            switch result {
            case .success(let leagues):
                actualLeagues = leagues
                expectation.fulfill()
            case .failure(let error):
                print("Error:\(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssert(expected == actualLeagues)
    }
}
