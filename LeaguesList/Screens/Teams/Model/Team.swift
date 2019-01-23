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

extension Team: Equatable {
    static func == (lhs: Team, rhs: Team) -> Bool {
        return
            lhs.fullName == rhs.fullName &&
            lhs.name == rhs.name &&
            lhs.location == rhs.location &&
            lhs.logoUrl == rhs.logoUrl &&
            lhs.colour1Hex == rhs.colour1Hex &&
            lhs.colour2Hex == rhs.colour2Hex
    }
}

extension Team: Decodable {
    enum TeamDecodingKeys: String, CodingKey {
        case fullName = "full_name"
        case name
        case location
        case logoUrl = "logo"
        case colour1Hex = "colour_1"
        case colour2Hex = "colour_2"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TeamDecodingKeys.self)
        
        fullName = try values.decode(String.self, forKey: .fullName)
        name = try values.decode(String.self, forKey: .name)
        location = try values.decode(String.self, forKey: .location)
        logoUrl = try? values.decode(String.self, forKey: .logoUrl)
        colour1Hex = try? values.decode(String.self, forKey: .colour1Hex)
        colour2Hex = try? values.decode(String.self, forKey: .colour2Hex)
    }
}

extension Team: TeamCellViewModelProducer {
    func toTeamCellViewModel() -> TeamCellViewModel {
        
        
        
        
        
        
        let viewModel = TeamCellViewModel(fullNameLabelText: "Hello")
        return viewModel
    }    
}
