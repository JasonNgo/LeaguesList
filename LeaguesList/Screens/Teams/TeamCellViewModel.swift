//
//  TeamCellViewModel.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

struct TeamCellViewModel {
    var fullNameLabelText: String
    var logoUrl: URL?
    var primaryColour: UIColor?
    var secondaryColor: UIColor?
}

extension TeamCellViewModel {
    init(team: Team) {
        self.fullNameLabelText = team.fullName
        
        if let url = URL(string: team.logoUrl ?? "") {
            self.logoUrl = url
        }
        
        if let colour1Hex = team.colour1Hex {
            primaryColour = UIColor(hexFromString: colour1Hex)
        }
        
        if let colour2Hex = team.colour2Hex {
            secondaryColor = UIColor(hexFromString: colour2Hex)
        }
    }
}
