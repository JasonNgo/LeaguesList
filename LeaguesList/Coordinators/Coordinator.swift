//
//  Coordinator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

// TODO: Update coordinators to handle coordinator lifecycle

/// Coordinators are a class used to control the navigation flow and are used to inject the
/// required depenecies into the screens they control.
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func add(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    func remove(childCoordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
    }
}
