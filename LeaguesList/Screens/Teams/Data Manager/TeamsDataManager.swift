//
//  TeamsDataManager.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import Foundation

final class TeamsDataManager {
    private let fileAccessor: FileAccessor<TheScoreEndPoint>
    
    init(fileAccessor: FileAccessor<TheScoreEndPoint>) {
        self.fileAccessor = fileAccessor
    }
    
    
}
