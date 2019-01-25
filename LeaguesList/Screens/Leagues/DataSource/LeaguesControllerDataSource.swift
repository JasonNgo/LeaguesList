//
//  LeaguesControllerDataSource.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-25.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class LeaguesControllerDataSource: NSObject {
    private let leaguesDataManager: LeaguesDataManager
    private let reuseId = "LeagueCell"
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    
    private let emptyStateMessage = "No Data Found"
    private let emptyStateDescription = "\n\nPlease try loading the page\nagain at a later time"
    
    init(leaguesDataManager: LeaguesDataManager) {
        self.leaguesDataManager = leaguesDataManager
        super.init()
//        refreshLeagueItems()
    }
    
    func refreshLeagueItems() {
        leaguesDataManager.fetchListOfLeagues { result in
            switch result {
            case .success(let leagues):
                self.leagues = leagues
                self.filteredLeagues = leagues
            case .failure:
                self.leagues = []
                self.filteredLeagues = []
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> League {
        return filteredLeagues[indexPath.item]
    }
    
    func filterResultsBy(_ searchText: String) {
        if searchText.isEmpty {
            filteredLeagues = leagues
        } else {
            filteredLeagues = leagues.filter({ league -> Bool in
                return
                    league.fullName.lowercased().contains(searchText.lowercased()) ||
                    league.slug.lowercased().contains(searchText.lowercased())
            })
        }
    }
    
    func backgroundView(for collectionView: UICollectionView) -> UIView? {
        if leagues.count == 0 {
            return createEmptyStateView(for: collectionView)
        } else {
            return nil
            
//            if filteredTeams.count == 0 {
//                collectionView.setEmptyMessage("", description: noSearchResultsString)
//            } else {
//                return nil
//            }
        }
    }
    
    private func createEmptyStateView(for collectionView: UICollectionView) -> UIView {
        let frame = CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
        let messageLabel = UILabel(frame: frame)
        
        let messageTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline).withSize(30)
        ]
        
        let descriptionTextAttributes = [
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline).withSize(22)
        ]
        
        let attributedText = NSMutableAttributedString(
            string: emptyStateMessage,
            attributes: messageTextAttributes
        )
        
        let descriptionText = NSAttributedString(
            string: emptyStateDescription,
            attributes: descriptionTextAttributes
        )
        
        attributedText.append(descriptionText)
        messageLabel.attributedText = attributedText
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        return messageLabel
    }
}

// MARK: - UICollectionViewDataSource
extension LeaguesControllerDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredLeagues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
            fatalError("Unable to dequeue cell")
        }
        
        cell.league = filteredLeagues[indexPath.item]
        return cell
    }
}
