//
//  TeamCellConfigurator.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-02-02.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

class TeamCellConfigurator {
    func configure(cell: TeamCell, with team: Team) {
        cell.teamFullNameLabel.text = team.fullName
        
        if let logoUrl = team.logoUrl, let url = URL(string: logoUrl) {
            cell.logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground) {
                (image, _, _, _) in
                guard let image = image else { return }
                cell.logoImageView.image = image
                cell.showImageView()
            }
            
            return
        }
        
        if let mainColourHex = team.colour1Hex {
            let colourImage = UIColor(hexFromString: mainColourHex).image()
            cell.logoImageView.image = colourImage
            cell.showImageView()
            
            return
        }
        
        // Unable to fetch imageUrl or colour hex so hide imageview
        cell.hideImageView()
    }
}
