//
//  Router.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

/// Builds requests based on endpoints. Executes network requests and handles networking related logic.
final class Router<EndPoint: EndPointType>: NetworkRouter {
    private let session: URLSession
    // TODO: Change to operation queue to sending multiple requests
    private var task: URLSessionTask?
    
    init(configuration: URLSessionConfiguration = .default) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func request(_ endpoint: EndPoint, completion: @escaping (Result<Data, RouterError>) -> Void) {
        do {
            let request = try self.buildRequest(from: endpoint)
            task = session.dataTask(with: request) {
                data, response, error in
                
                // Example response handling
                if let error = error {
                    completion(.failure(RouterError.other(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(RouterError.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(RouterError.invalidData))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    completion(.success(data))
                }
            }
        } catch {
            completion(.failure(RouterError.unableToBuildRequest))
        }
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}

extension Router {
    private func buildRequest(from endpoint: EndPointType) throws -> URLRequest {
        let url = endpoint.baseUrl.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endpoint.httpMethod.rawValue
        
        do {
            switch endpoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let urlParameters, let bodyParameters):
                try self.configureParameters(urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
            case .requestParametersAndHeaders(let urlParameters, let bodyParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(urlParameters: urlParameters, bodyParameters: bodyParameters, request: &request)
            }
        } catch {
            throw error
        }
        
        return request
    }
    
    private func configureParameters(urlParameters: Parameters?, bodyParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
    }   
}

