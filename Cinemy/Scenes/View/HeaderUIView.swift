//
//  HeaderUIView.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit
import SDWebImage
class HeaderUIView: UIView {
    private let playButton : UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    private let downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    private let headerImageView : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(named: "headerImage")
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerImageView)
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        addGradient()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.headerImageView.frame = bounds
    }
}

extension HeaderUIView {
    public func configureHeaderView(with model : TitleViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else {
                   return
        }
        headerImageView.sd_setImage(with: url)
    }
    
    private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 80),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -80),
            downloadButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor,constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)

    }
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
        UIColor.clear.cgColor,
        UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
}
