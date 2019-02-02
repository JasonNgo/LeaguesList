//
//  LeagueCellConfigurator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-02-02.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

class LeagueCellConfigurator {
    func configure(cell: LeagueCell, with league: League) {
        cell.leagueFullNameLabel.text = league.fullName
    }    
}
