//
//  Result.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-21.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public enum Result<T, U> where U: Error {
    case success(T)
    case failure(U)
}
