//
//  LeaguesListLeagueModelTests
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesListLeagueModelTests: XCTestCase {
    
    // MARK: - Model

    func testLeagueModelCreation() {
        let fullName = "NHL Hockey"
        let slug = "nhl"
        
        let league = League(fullName: fullName, slug: slug)
        
        XCTAssert(league.fullName == "NHL Hockey")
        XCTAssert(league.slug == "nhl")
    }
    
    // MARK: - ViewModel
    
    func testLeagueViewModelCreation() {
        let fullName = "NHL Hockey"
        let slug = "nhl"
        
        let league = League(fullName: fullName, slug: slug)
        let leagueViewModel = LeagueCellViewModel(league: league)
        
        XCTAssert(leagueViewModel.fullNameLabelText == fullName)
    }
    
}
