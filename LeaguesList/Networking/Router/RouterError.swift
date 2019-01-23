//
//  RouterError.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public enum RouterError: Error {
    case unableToBuildRequest
    case invalidResponse
    case invalidData
    case other(Error)
}
