//
//  TitleCollectionViewCell.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit
import SDWebImage
class TitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "TitleCollectionViewCell"
    
    private let titleImageView : UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(titleImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleImageView.frame = contentView.bounds
    }
    
    public func configureCollectionViewCell(with model : String){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
                   return
        }
        titleImageView.sd_setImage(with: url)
    }
}
