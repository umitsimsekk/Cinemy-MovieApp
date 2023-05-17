//
//  HomeViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit
enum Section : Int {
    case TrendingMovies = 0
}

class HomeViewController: UIViewController {
    private var headerView : HeaderUIView?
    private var randomMovie : Title?
    
    private let titleNames : Array<String> = ["Trending Movies","Trending Tvs","Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBrown
        view.addSubview(homeTableView)
        setTableViewDelegates()
        
        headerView = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeTableView.tableHeaderView = headerView
        
        configureNavbar()
        getData()
                
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeTableView.frame = view.bounds
    }
}
extension HomeViewController {
    private func getData(){
        APICaller.shared.getTrendingMovies { result in
            switch result{
            case.success(let title):
                let selectedTitle = title.randomElement()
                self.randomMovie = selectedTitle
                self.headerView?.configureHeaderView(with: TitleViewModel(posterUrl: selectedTitle?.poster_path ?? "", titleName: selectedTitle?.original_name ?? selectedTitle?.original_title ?? ""))
            case .failure(let error):
                print(error)
            }
        }
    }
    private func setTableViewDelegates(){
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
    }
    private func configureNavbar(){
        
         navigationItem.rightBarButtonItems = [
             UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
         UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
         ]
         navigationController?.navigationBar.tintColor = .black
         var image = UIImage(named: "c_letter")
         image = image?.withRenderingMode(.alwaysOriginal)
         navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
    }
}
extension HomeViewController : CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configureTitlePreviewVC(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleNames.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        switch indexPath.section{
        case 0:
            APICaller.shared.getTrendingMovies { result in
                switch result{
                case.success(let title):
                    cell.configureCollectionViewTableViewCell(with: title)
                   
                case .failure(let error):
                    print(error)
                }
            
            }
        case 1:
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case.success(let title):
                    cell.configureCollectionViewTableViewCell(with: title)
                   
                case .failure(let error):
                    print(error)
                }
            
            }
        case 2:
            APICaller.shared.getPopular { result in
                switch result{
                case.success(let title):
                    cell.configureCollectionViewTableViewCell(with: title)
                   
                case .failure(let error):
                    print(error)
                }
            
            }
        case 3:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case.success(let title):
                    cell.configureCollectionViewTableViewCell(with: title)
                   
                case .failure(let error):
                    print(error)
                }
            
            }
        case 4:
            APICaller.shared.getTopRated { result in
                switch result{
                case.success(let title):
                    cell.configureCollectionViewTableViewCell(with: title)
                   
                case .failure(let error):
                    print(error)
                }
            
            }
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleNames[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .black
    }
}
