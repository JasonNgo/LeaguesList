//
//  TeamCell.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

final class TeamCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private let teamFullNameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "Team Name"
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - ViewModel
    var teamCellViewModel: TeamCellViewModel! {
        didSet {
            teamFullNameLabel.text = teamCellViewModel.fullNameLabelText
            
            // Attempt to load image if the url exists
            guard let logoUrl = teamCellViewModel.logoUrl, let url = URL(string: logoUrl) else {
                // If imageUrl doesn't exist attempt to load teams main colour as an image
                guard let mainColour = teamCellViewModel.colour1 else {
                    logoImageView.widthAnchor.constraint(equalToConstant: 0).isActive = true
                    logoImageView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                    return
                }
                
                let colourImage = UIColor(hexFromString: mainColour).image()
                logoImageView.image = colourImage
                return
            }
            
            logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground) {
                (image, _, _, _) in
                guard let image = image else { return }
                self.logoImageView.image = image
            }
        }
    }
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        addSubview(teamFullNameLabel)
        addSubview(logoImageView)
        
        logoImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 8, bottom: 0, right: 0),
            size: .init(width: 30, height: 30)
        )
        
        teamFullNameLabel.anchor(
            top: topAnchor,
            leading: logoImageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8)
        )
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
