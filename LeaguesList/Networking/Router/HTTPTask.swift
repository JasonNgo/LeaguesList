//
//  HTTPTask.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case request
    case requestParameters(urlParameters: Parameters?, bodyParameters: Parameters?)
    case requestParametersAndHeaders(urlParameters: Parameters?, bodyParameters: Parameters, additionalHeaders: HTTPHeaders?)
}

