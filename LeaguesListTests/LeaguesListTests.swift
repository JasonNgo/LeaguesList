//
//  LeaguesListTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-21.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesListTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLeagueCellViewModelProducer() {
        let fullName = "NHL Hockey"
        let slug = "nhl"
        
        let league = League(fullName: fullName, slug: slug)
        let leagueViewModel = league.toLeagueCellViewModel()
        
        let expected = "NHL Hockey"
        let actual = leagueViewModel.fullNameLabelText
        
        XCTAssert(expected == actual)
    }
    
    func testLeagueDecodable() {
        let fullName = "NFL Football"
        let slug = "nfl"
        
        let jsonObject = [
            "full_name": fullName,
            "slug": slug
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let decodedLeague = try JSONDecoder().decode(League.self, from: data)
            
            let expectedFullName = "NFL Football"
            let expectedSlug = "nfl"
            
            let actualFullName = decodedLeague.fullName
            let actualSlug = decodedLeague.slug
            
            XCTAssert(expectedFullName == actualFullName)
            XCTAssert(expectedSlug == actualSlug)
        } catch {
            XCTAssert(false)
        }
    }
    
}
