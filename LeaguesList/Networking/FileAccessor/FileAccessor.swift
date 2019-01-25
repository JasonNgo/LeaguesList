//
//  FileManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

enum FileAccessorError: Error {
    case unableToFetchData
}

final class FileAccessor<EndPoint: EndPointType> {
    func request(_ endpoint: EndPoint, completion: @escaping (Result<Data, FileAccessorError>) -> Void) {
        do {
            let url = endpoint.baseUrl
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(FileAccessorError.unableToFetchData))
        }
    }
}
