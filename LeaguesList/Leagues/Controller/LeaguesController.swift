//
//  LeaguesController.swift
//  LeaguesList
//
//  Created by Jason Ngo on 2019-01-22.
//  Copyright © 2019 Jason Ngo. All rights reserved.
//

import UIKit

final class LeaguesController: UIViewController {
    
    // MARK: - Styling Constants
    private let cellWidth = UIScreen.main.bounds.width
    private let cellHeight: CGFloat = 75
    private let minimumLineSpacingForSection: CGFloat = 5
    
    private let reuseId = "LeagueCell"
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(LeagueCell.self, forCellWithReuseIdentifier: reuseId)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LeaguesController: UICollectionViewDelegate {
    
}

extension LeaguesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? LeagueCell else {
            fatalError("Unable to dequeue League Cell")
        }
        
        let viewModel = LeagueCellViewModel(fullNameLabelText: "Hello World")
        cell.leagueViewModel = viewModel
        
        return cell
    }
}

extension LeaguesController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
}
