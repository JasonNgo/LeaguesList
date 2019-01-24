//
//  League.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

/// Model object representing a League. Conforms to Decodable and is able to produce LeagueCellViewModels.
struct League {
    var fullName: String
    var slug: String
}

extension League: Equatable {
    static func == (lhs: League, rhs: League) -> Bool {
        return lhs.fullName == rhs.fullName && lhs.slug == rhs.slug
    }
}

extension League: Decodable {
    enum LeagueDecodingKeys: String, CodingKey {
        case fullName = "full_name"
        case slug
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: LeagueDecodingKeys.self)
        
        fullName = try values.decode(String.self, forKey: .fullName)
        slug = try values.decode(String.self, forKey: .slug)
    }
}
