//
//  TeamCell.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-23.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

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
            guard let data = teamCellViewModel.imageData else { return }
            let image = UIImage(data: data)
            logoImageView.image = image
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
        
        teamFullNameLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
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
