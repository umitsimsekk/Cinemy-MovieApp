//
//  CollectionViewTableViewCell.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    var titles : Array<Title> = []
    
    private let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collView.register(TitleCollectionViewCell.self , forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        setCollectionViewDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
}

extension CollectionViewTableViewCell {
    private func  setCollectionViewDelegates(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    public func configureCollectionViewTableViewCell(with model : [Title]){
        self.titles = model
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
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
