//
//  EncodingError.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-18.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

enum EncodingError: String, Error {
    case parametersNil = "Parameters were nil"
    case encodingFailed = "Parameter encoding failed"
    case missingUrl = "URL is nil"
}
