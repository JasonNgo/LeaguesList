//
//  NetworkRouter.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (Result<Data, RouterError>) -> Void

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ endpoint: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

