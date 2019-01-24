//
//  TeamCellViewModel.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct TeamCellViewModel {
    var fullNameLabelText: String
    var name: String
    var location: String?
    var logoUrl: String?
    var colour1: String?
    var colour2: String?
    
    // Included in ViewModel for filtering purposes
}

extension TeamCellViewModel {
    init(team: Team) {
        self.fullNameLabelText = team.fullName
        self.name = team.name
        self.location = team.location
        self.logoUrl = team.logoUrl
        self.colour1 = team.colour1Hex
        self.colour2 = team.colour2Hex
    }
}
