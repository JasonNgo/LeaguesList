//
//  TeamCell.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit
import SDWebImage

/// UICollectionViewCell Subclass that displays a teams information for the TeamsController cell
final class TeamCell: UICollectionViewCell {
    
    // MARK: - Subviews
    
    private let teamFullNameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "Team Name"
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    // MARK: - Constraints
    private var logoMaximizedWidthConstraint: NSLayoutConstraint!
    private var logoMinimizedWidthConstraint: NSLayoutConstraint!
    private let logoImageViewSize: CGFloat = 44
    
    // MARK: - Model
    
    var team: Team! {
        didSet {
            teamFullNameLabel.text = team.fullName
            
            // Attempt to load image if the url exists
            guard let logoUrl = team.logoUrl, let url = URL(string: logoUrl) else {
                // If imageUrl doesn't exist attempt to load teams main colour as an image
                guard let mainColour = team.colour1Hex else {
                    logoMaximizedWidthConstraint.isActive = false
                    logoMinimizedWidthConstraint.isActive = true
                    return
                }
                
                let colourImage = UIColor(hexFromString: mainColour).image()
                logoImageView.image = colourImage
                logoMinimizedWidthConstraint.isActive = false
                logoMaximizedWidthConstraint.isActive = true
                return
            }
            
            logoImageView.sd_setImage(with: url, placeholderImage: nil, options: .continueInBackground) {
                (image, _, _, _) in
                guard let image = image else { return }
                self.logoImageView.image = image
                self.logoMinimizedWidthConstraint.isActive = false
                self.logoMaximizedWidthConstraint.isActive = true
            }
        }
    }
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        addSubview(teamFullNameLabel)
        addSubview(logoImageView)
        addSubview(dividerView)
        
        logoMaximizedWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: logoImageViewSize)
        logoMinimizedWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 0)
        
        logoImageView.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 8, bottom: 0, right: 0)
        )
        logoImageView.heightAnchor.constraint(equalToConstant: logoImageViewSize).isActive = true
        logoMaximizedWidthConstraint.isActive = true
        logoMinimizedWidthConstraint.isActive = false
        
        teamFullNameLabel.anchor(
            top: topAnchor,
            leading: logoImageView.trailingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8)
        )
        
        dividerView.anchor(
            top: nil,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
