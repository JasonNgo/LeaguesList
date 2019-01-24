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
    var imageData: Data?
    var colour1: String?
    var colour2: String?
    
    // Included in ViewModel for filtering purposes
    var location: String
    var name: String
}

extension TeamCellViewModel {
    init(team: Team, imageData: Data?) {
        self.fullNameLabelText = team.fullName
        self.imageData = imageData
        self.colour1 = team.colour1Hex
        self.colour2 = team.colour2Hex
        self.location = team.location
        self.name = team.name
    }
}
