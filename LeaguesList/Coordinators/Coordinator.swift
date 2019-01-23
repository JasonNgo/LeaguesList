//
//  Coordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

/// Coordinators are a class used to control the navigation flow and are used to inject the
/// required depenecies into the screens they control.
protocol Coordinator {
    func start()
}
