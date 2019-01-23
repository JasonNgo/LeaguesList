//
//  FileManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

final class FileAccessor<EndPoint: EndPointType>: FileAccessorRequest {
    func request(_ endpoint: EndPoint, completion: @escaping FileAccessorCompletion) {
        do {
            let url = endpoint.baseUrl
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(FileAccessorError.unableToFetchData))
        }
    }
}
