//
//  LeaguesFileAccessorTests.swift
//  LeaguesListTests
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import XCTest
@testable import LeaguesList

class LeaguesFileAccessorTests: XCTestCase {
    
    func testDecodeLeaguesDataFromBundleURL() {
        let fileAccessor = FileAccessor<TheScoreEndPoint>()
        
        fileAccessor.request(.leagues) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNoThrow(try! JSONDecoder().decode([League].self, from: data))
            case .failure:
                XCTFail()
            }
        }
    }
    
}
