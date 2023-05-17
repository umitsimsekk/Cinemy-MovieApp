//
//  TitlePreviewViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 17.05.2023.
//

import UIKit
import WebKit
class TitlePreviewViewController: UIViewController {
    private let downloadButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.backgroundColor = .red
        return button
    }()
    
    private let overviewLabel : UILabel = {
       let overviewLabel = UILabel()
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = .systemFont(ofSize: 18, weight: .regular)
        overviewLabel.text = "Text TextText TextText TextText TextText TextText Text"
        overviewLabel.numberOfLines = 0
        return overviewLabel
    }()
    
    
    private let titleLabel : UILabel = {
       let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 22,weight: .semibold)
        title.text = "Harry potter"
        return title
    }()
    private let webView : WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(downloadButton)
        view.addSubview(overviewLabel)
        view.addSubview(titleLabel)
        view.addSubview(webView)
        
        applyConstraints()
    }
   
}

extension TitlePreviewViewController{
    private func applyConstraints(){
        let webViewConstraints = [
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor,constant: 100),
            webView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor,constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20)
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor,constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configureTitlePreviewVC(with model : TitlePreviewViewModel){
        titleLabel.text = model.title
        overviewLabel.text = model.overview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {
                    return
        }
        webView.load(URLRequest(url: url))
    }
}
