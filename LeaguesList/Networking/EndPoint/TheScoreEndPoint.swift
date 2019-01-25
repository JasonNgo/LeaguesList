//
//  TheScoreEndPoint.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

public enum TheScoreEndPoint {
    case leagues
    case teams(slug: String)
}

extension TheScoreEndPoint: EndPointType {
    var baseUrl: URL {
        switch self {
        case .leagues:
            guard let url = Bundle.main.url(forResource: "leagues", withExtension: "json") else {
                fatalError("Unable to build URL")
            }
            return url
        case .teams(let slug):
            guard let url = Bundle.main.url(forResource: slug, withExtension: "json", subdirectory: "leagues") else {
                fatalError("Unable to build URL")
            }
            return url
        }
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
