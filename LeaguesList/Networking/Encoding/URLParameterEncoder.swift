//
//  URLParameterEncoder.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public struct URLParameterEncoder: ParameterEncoder {
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw EncodingError.missingUrl }
        guard !parameters.isEmpty else { throw EncodingError.parametersNil }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryItems: [URLQueryItem] = []
            parameters.forEach { queryItems.append(URLQueryItem(name: $0.key, value: String(describing: $0.value))) }
            urlComponents.queryItems = queryItems
            
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
