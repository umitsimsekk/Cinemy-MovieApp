//
//  TitleTableViewCell.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 17.05.2023.
//

import UIKit
import SDWebImage
class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    private let titleImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private let titleNameLabel : UILabel = {
       let titleName = UILabel()
        titleName.translatesAutoresizingMaskIntoConstraints = false
        return titleName
    }()
    
    private let playButton : UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleImageView)
        contentView.addSubview(titleNameLabel)
        contentView.addSubview(playButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TitleTableViewCell {
    public func configureTitleTableViewCell(with model : TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
                   return
        }
        titleImageView.sd_setImage(with: url)
        titleNameLabel.text = model.titleName
        
    }
    
    private func applyConstraints(){
        let titleImageViewConstraints = [
            titleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8),
            titleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
            titleImageView.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let titleNameLabelConstraints = [
            titleNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleNameLabel.leadingAnchor.constraint(equalTo: titleImageView.trailingAnchor,constant: 10)
        ]
        
        let playButtonConstraints = [
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20)
        ]
        NSLayoutConstraint.activate(titleImageViewConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
}
