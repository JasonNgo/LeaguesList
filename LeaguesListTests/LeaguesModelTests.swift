//
//  LeaguesModelTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesModelTests: XCTestCase {
    
    // MARK: - League Model Tests
    
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
            XCTFail()
        }
    }
    
    // MARK: - Team Model Tests
    
//    func testTeamCellViewModelProducer() {
//        let fullName = "Boston Bruins"
//        let location = "Boston"
//        let logo = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
//        let colour1 = "FDB930"
//        let colour2 = "343434"
//        let name = "Bruins"
//
//        let team = Team(fullName: fullName, name: name, location: location, logoImageUrl: logo, colour1: colour1, colour2: colour2)
//        let teamViewModel = team.toTeamCellViewModel()
//
//        let expected = "Boston Bruins"
//        let actual = teamViewModel.fullNameLabelText
//
//        XCTAssert(expected == actual)
//    }
    
}
