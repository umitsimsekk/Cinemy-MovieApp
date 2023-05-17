//
//  SearchResultsViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 17.05.2023.
//

import UIKit

class SearchResultsViewController: UIViewController {
    var titles : Array<Title> = []
    public let resultCollView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultCollView)
        setCollectionViewDelegates()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultCollView.frame = view.bounds
    }
    private func setCollectionViewDelegates(){
        self.resultCollView.delegate = self
        self.resultCollView.dataSource = self
    }
}
extension SearchResultsViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureCollectionViewCell(with: titles[indexPath.row].poster_path ?? "")
        return cell
    }
}


