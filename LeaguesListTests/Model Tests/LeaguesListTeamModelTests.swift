//
//  LeaguesListTeamModelTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-02-07.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesListTeamModelTests: XCTestCase {
    
    // MARK: - Model
    
    func testTeamModelCreation() {
        let fullName = "Boston Bruins"
        let location = "Boston"
        let logoUrl = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
        let colour1 = "FDB930"
        let colour2 = "343434"
        let name = "Bruins"
        
        let team = Team(fullName: fullName, name: name, location: location, logoUrl: logoUrl, colour1Hex: colour1, colour2Hex: colour2)
        
        XCTAssert(team.fullName == fullName)
        XCTAssert(team.location == location)
        XCTAssert(team.logoUrl == logoUrl)
        XCTAssert(team.colour1Hex == colour1)
        XCTAssert(team.colour2Hex == colour2)
        XCTAssert(team.name == name)
    }
    
    // MARK: - ViewModel
    
    func testTeamCellViewModelCreation() {
        let fullName = "Boston Bruins"
        let location = "Boston"
        let logoUrl = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
        let colour1 = "FDB930"
        let colour2 = "343434"
        let name = "Bruins"
        
        let expectedFullNameLabelText = fullName
        let expectedUrl: URL? = URL(string: logoUrl)!
        let expectedPrimaryColour: UIColor? = UIColor(hexFromString: colour1)
        let expectedSecondaryColour: UIColor? = UIColor(hexFromString: colour2)
        
        let team = Team(fullName: fullName, name: name, location: location, logoUrl: logoUrl, colour1Hex: colour1, colour2Hex: colour2)
        let teamViewModel = TeamCellViewModel(team: team)
        
        XCTAssert(teamViewModel.fullNameLabelText == expectedFullNameLabelText)
        XCTAssert(teamViewModel.logoUrl == expectedUrl)
        XCTAssert(teamViewModel.primaryColour == expectedPrimaryColour)
        XCTAssert(teamViewModel.secondaryColor == expectedSecondaryColour)
    }
    
    func testTeamCellViewModelCreationMissingUrl() {
        let fullName = "Boston Bruins"
        let location = "Boston"
        let logoUrl = ""
        let colour1 = "FDB930"
        let colour2 = "343434"
        let name = "Bruins"
        
        let expectedFullNameLabelText = fullName
        let expectedUrl: URL? = nil
        let expectedPrimaryColour: UIColor? = UIColor(hexFromString: colour1)
        let expectedSecondaryColour: UIColor? = UIColor(hexFromString: colour2)
        
        let team = Team(fullName: fullName, name: name, location: location, logoUrl: logoUrl, colour1Hex: colour1, colour2Hex: colour2)
        let teamViewModel = TeamCellViewModel(team: team)
        
        XCTAssert(teamViewModel.fullNameLabelText == expectedFullNameLabelText)
        XCTAssert(teamViewModel.logoUrl == expectedUrl)
        XCTAssert(teamViewModel.primaryColour == expectedPrimaryColour)
        XCTAssert(teamViewModel.secondaryColor == expectedSecondaryColour)
    }
    
    func testTeamCellViewModelCreationMissingColour() {
        let fullName = "Boston Bruins"
        let location = "Boston"
        let logoUrl = "https://d12smlnp5321d2.cloudfront.net/hockey/team/1/logo.png"
        let colour2 = "343434"
        let name = "Bruins"
        
        // expectations
        let expectedFullNameLabelText = fullName
        let expectedUrl: URL? = URL(string: logoUrl)!
        let expectedPrimaryColour: UIColor? = nil
        let expectedSecondaryColour: UIColor? = UIColor(hexFromString: colour2)
        
        let team = Team(fullName: fullName, name: name, location: location, logoUrl: logoUrl, colour1Hex: nil, colour2Hex: colour2)
        let teamViewModel = TeamCellViewModel(team: team)
        
        XCTAssert(teamViewModel.fullNameLabelText == expectedFullNameLabelText)
        XCTAssert(teamViewModel.logoUrl == expectedUrl)
        XCTAssert(teamViewModel.primaryColour == expectedPrimaryColour)
        XCTAssert(teamViewModel.secondaryColor == expectedSecondaryColour)
    }
    
}
