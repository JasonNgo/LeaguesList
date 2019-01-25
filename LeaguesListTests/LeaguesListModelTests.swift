//
//  LeaguesModelTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesListModelTests: XCTestCase {
    
    // MARK: - League Model Tests
    
    func testLeagueViewModelCreation() {
        let fullName = "NHL Hockey"
        let slug = "nhl"
        
        let league = League(fullName: fullName, slug: slug)
        let leagueViewModel = LeagueCellViewModel(league: league)
        
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
    
    func testTeamCellViewModelCreation() {
        let fullName = "Boston Bruins"
        let location = "Boston"
        let logoUrl = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
        let colour1 = "FDB930"
        let colour2 = "343434"
        let name = "Bruins"

        let team = Team(fullName: fullName, name: name, location: location, logoUrl: logoUrl, colour1Hex: colour1, colour2Hex: colour2)
        let teamViewModel = TeamCellViewModel(team: team)

        XCTAssert(teamViewModel.fullNameLabelText == fullName)
        XCTAssert(teamViewModel.name == name)
        XCTAssert(teamViewModel.location == location)
        XCTAssert(teamViewModel.logoUrl == logoUrl)
        XCTAssert(teamViewModel.colour1 == colour1)
        XCTAssert(teamViewModel.colour2 == colour2)
    }
    
    func testTeamDecodable() {
        let location = "Boston"
        let fullName = "Boston Bruins"
        let logoUrl = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
        let colour2 = "343434"
        let name = "Bruins"
        let colour1 = "FDB930"

        let jsonObject = [
            "location": location,
            "full_name": fullName,
            "logo": logoUrl,
            "colour_2": colour2,
            "name": name,
            "colour_1": colour1
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            let decodedLeague = try JSONDecoder().decode(Team.self, from: data)
            
            XCTAssert(decodedLeague.location == location)
            XCTAssert(decodedLeague.fullName == fullName)
            XCTAssert(decodedLeague.logoUrl == logoUrl)
            XCTAssert(decodedLeague.colour2Hex == colour2)
            XCTAssert(decodedLeague.name == name)
            XCTAssert(decodedLeague.colour1Hex == colour1)
        } catch {
            XCTFail()
        }
    }
}
