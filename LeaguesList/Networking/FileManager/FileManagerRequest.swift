//
//  FileManagerRequest.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public enum FileAccessorError: Error {
    case unableToFetchData
}

public typealias FileAccessorCompletion = (Result<Data, FileAccessorError>) -> Void

protocol FileAccessorRequest: class {
    associatedtype EndPointType
    func request(_ endpoint: EndPointType, completion: @escaping FileAccessorCompletion)
}
