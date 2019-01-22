//
//  TeamCellViewModelProducer.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

protocol TeamCellViewModelProducer {
    func toTeamCellViewModel() -> TeamCellViewModel
}
