//
//  Safe.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-02-04.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

struct Safe<Base: Decodable>: Decodable {
    let value: Base?
    
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }
}
