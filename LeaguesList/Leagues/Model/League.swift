//
//  League.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct League {
    var fullName: String
    var slug: String
}

extension League: Decodable {
    enum LeagueEncodingKeys: String, CodingKey {
        case fullName = "full_name"
        case slug
    }
    
    init(from decoder: Decoder) throws {
        let leagueContainer = try decoder.container(keyedBy: LeagueEncodingKeys.self)
        
        fullName = try leagueContainer.decode(String.self, forKey: .fullName)
        slug = try leagueContainer.decode(String.self, forKey: .slug)
    }
}

extension League: LeagueCellViewModelProducer {
    func toLeagueCellViewModel() -> LeagueCellViewModel {
        return LeagueCellViewModel(fullNameLabelText: fullName)
    }
}
