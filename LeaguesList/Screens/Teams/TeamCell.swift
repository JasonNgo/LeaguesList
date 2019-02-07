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
        let label = UILabel()
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
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        contentView.addSubview(teamFullNameLabel)
        contentView.addSubview(logoImageView)
        contentView.addSubview(dividerView)
        
        logoMaximizedWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: logoImageViewSize)
        logoMinimizedWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 0)
        
        logoImageView.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 8, left: 8, bottom: 0, right: 0)
        )
        logoImageView.heightAnchor.constraint(equalToConstant: logoImageViewSize).isActive = true
        hideImageView()
        
        teamFullNameLabel.anchor(
            top: contentView.topAnchor,
            leading: logoImageView.trailingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 8, left: 8, bottom: 8, right: 8)
        )
        
        dividerView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
    }
    
    func configureCell(using viewModel: TeamCellViewModel) {
        teamFullNameLabel.text = viewModel.fullNameLabelText
        
        if let logoUrl = viewModel.logoUrl {
            logoImageView.sd_setImage(with: logoUrl, placeholderImage: nil, options: .continueInBackground) {
                (image, _, _, _) in
                guard let image = image else { return }
                self.logoImageView.image = image
                self.showImageView()
            }
                
            return
        }
        
        if let primaryColour = viewModel.primaryColour {
            let colourImage = primaryColour.image()
            logoImageView.image = colourImage
            showImageView()
            
            return
        }
        
        // Unable to fetch imageUrl or colour hex so hide imageview
        hideImageView()
    }
    
    func hideImageView() {
        logoMaximizedWidthConstraint.isActive = false
        logoMinimizedWidthConstraint.isActive = true
    }
    
    func showImageView() {
        logoMinimizedWidthConstraint.isActive = false
        logoMaximizedWidthConstraint.isActive = true
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
