//
//  Team.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct Team {
    let fullName: String
    let name: String
    let location: String?
    let logoUrl: String?
    let colour1Hex: String?
    let colour2Hex: String?
}

extension Team: Decodable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case name
        case location
        case logoUrl = "logo"
        case colour1Hex = "colour_1"
        case colour2Hex = "colour_2"
    }
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
