//
//  CollectionViewTableViewCell.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit
protocol CollectionViewTableViewCellDelegate : AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell :CollectionViewTableViewCell, viewModel : TitlePreviewViewModel)
}
class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate : CollectionViewTableViewCellDelegate?
    
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
    
    private func downloadTitleAt(indexPath : IndexPath){
        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("downloaded")
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else {
            return
        }
        APICaller.shared.getMovie(with: titleName + " trailer") { result in
            switch result {
            case .success(let videoElement):
                let title = self.titles[indexPath.row]
                let titlePreviewModel = TitlePreviewViewModel(overview: title.overview ?? "", title: title.original_title ?? title.original_name ?? "", youtubeView: videoElement)
                self.delegate?.collectionViewTableViewCellDidTapCell(self, viewModel: titlePreviewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
          
          let config = UIContextMenuConfiguration(
              identifier: nil,
              previewProvider: nil) {[weak self] _ in
                  let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                      self?.downloadTitleAt(indexPath: indexPath)
                  }
                  return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
              }
          
          return config
      }
    
}
