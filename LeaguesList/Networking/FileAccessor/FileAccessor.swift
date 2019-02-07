//
//  FileManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation
import PromiseKit

enum FileAccessorError: Error {
    case unableToFetchData
}

final class FileAccessor<EndPoint: EndPointType> {
    func request(_ endpoint: EndPoint, completion: @escaping (Result<Data, FileAccessorError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                sleep(2)
                let url = endpoint.baseUrl
                let data = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    completion(.success(data))
                }
            } catch {
                completion(.failure(FileAccessorError.unableToFetchData))
            }
        }
    }
    
    func request(_ endpoint: EndPoint) -> Promise<Data> {
        return Promise { seal in
            let url = endpoint.baseUrl
            do {
                let data = try Data(contentsOf: url)
                seal.fulfill(data)
            } catch {
                seal.reject(FileAccessorError.unableToFetchData)
            }
        }
    }
}


