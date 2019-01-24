//
//  LeagueCellViewModel.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct LeagueCellViewModel {
    var fullNameLabelText: String
    var slug: String
}

extension LeagueCellViewModel {
    init(league: League) {
        self.fullNameLabelText = league.fullName
        self.slug = league.slug
    }
}
