//
//  UICollectionView+Extensions.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-24.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage(_ message: String, description: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
    
        let messageTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(30)
        ]
        
        let descriptionTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline).withSize(22)
        ]
        
        let attributedText = NSMutableAttributedString(
            string: message,
            attributes: messageTextAttributes
        )
        
        let descriptionText = NSAttributedString(
            string: description,
            attributes: descriptionTextAttributes
        )
        
        attributedText.append(descriptionText)
        messageLabel.attributedText = attributedText
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
