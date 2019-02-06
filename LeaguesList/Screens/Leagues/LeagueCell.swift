//
//  LeagueCell.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

/// CollectionViewCell displayed on collectionView of Leagues Controller
class LeagueCell: UICollectionViewCell {
    
    // MARK: - Subviews
    private let leagueFullNameLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.text = "League Name"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    // MARK: - Overrides
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        contentView.addSubview(leagueFullNameLabel)
        contentView.addSubview(dividerView)
        
        leagueFullNameLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 8, left: 16, bottom: 8, right: 16)
        )
        
        dividerView.anchor(
            top: nil,
            leading: contentView.leadingAnchor,
            bottom: contentView.bottomAnchor,
            trailing: contentView.trailingAnchor,
            padding: .init(top: 0, left: 16, bottom: 0, right: 0)
        )
    }
    
    // MARK: - Configuration
    
    func configureCell(using viewModel: LeagueCellViewModel) {
        leagueFullNameLabel.text = viewModel.fullNameLabelText
    }
    
    // MARK: - Required
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
