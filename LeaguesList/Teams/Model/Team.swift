//
//  Team.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct Team {
    var fullName: String
    var name: String
    var location: String
    var logoUrl: String?
    var colour1Hex: String?
    var colour2Hex: String?
}

extension Team: TeamCellViewModelProducer {
    func toTeamCellViewModel() -> TeamCellViewModel {
        
        
        
        
        
        
        let viewModel = TeamCellViewModel(fullNameLabelText: "Hello")
        return viewModel
    }    
}
