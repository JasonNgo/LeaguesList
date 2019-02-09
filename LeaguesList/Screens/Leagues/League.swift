//
//  League.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct League {
    let fullName: String
    let slug: String
}

extension League: Decodable {
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case slug
    }
}

extension League: Equatable {
    static func == (lhs: League, rhs: League) -> Bool {
        return
            lhs.fullName == rhs.fullName &&
            lhs.slug == rhs.slug
    }
}

