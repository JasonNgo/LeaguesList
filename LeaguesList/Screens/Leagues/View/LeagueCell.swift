//
//  LeagueCell.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// CollectionViewCell displayed on collectionView of Leagues Controller
final class LeagueCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private let leagueFullNameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "League Name"
        return label
    }()
    
    // MARK: - ViewModel
    var leagueViewModel: LeagueCellViewModel! {
        didSet {
            leagueFullNameLabel.text = leagueViewModel.fullNameLabelText
        }
    }
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        addSubview(leagueFullNameLabel)
        leagueFullNameLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16)
        )
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
