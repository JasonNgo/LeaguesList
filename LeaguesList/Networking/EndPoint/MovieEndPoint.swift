//
//  MovieEndPoint.swift
//  NetworkLayer
//
//  Created by Jason Ngo on 2019-01-21.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

/// Passed to the router class to build the URLRequest, adding the required headers
/// and data in order for the url to represent the correct endpoint.
public enum MovieEndPoint {
    case recommended(id: Int)
    case popular(page: Int)
    case newMovies(page: Int)
    case video(id: Int)
}

extension MovieEndPoint: EndPointType {
    var apiKey: String {
        return "1c076424515330fcd3fc119b734ef2a7"
    }

    var baseUrl: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/") else { fatalError("Unable to build URL") }
        return url
    }
    
    var path: String {
        switch self {
        case .recommended(let id):
            return("\(id)/recommendations")
        case .popular:
            return "popular"
        case .newMovies:
            return "now_playing"
        case .video(let id):
            return "\(id)/videos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .GET
    }
    
    var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            let urlParameters = [
                "api_key": apiKey,
                "page": page,
            ] as [String : Any]
            return .requestParameters(urlParameters: urlParameters, bodyParameters: nil)
        case .popular(let page):
            let urlParameters = [
                "api_key": apiKey,
                "language": "en-US",
                "page": page
            ] as [String : Any]
            return .requestParameters(urlParameters: urlParameters, bodyParameters: nil)
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
