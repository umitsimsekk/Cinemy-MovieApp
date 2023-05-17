//
//  SearchViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit

class SearchViewController: UIViewController {
    var titles : Array<Title> = []
    private let searchTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
        
    }()
    
    private let searchController : UISearchController = {
       let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Write something to search"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .systemMint
        view.addSubview(searchTableView)
        setTableViewDelegates()
        fetchData()
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        navigationController?.navigationBar.tintColor = .label
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.searchTableView.frame = view.bounds
    }
   
}
extension SearchViewController {
    private func setTableViewDelegates(){
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self
    }
    
    private func fetchData(){
        APICaller.shared.getDiscoverMovies { result in
            switch result {
            case .success(let title):
                self.titles = title
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let titleViewModel = TitleViewModel(posterUrl: title.poster_path ?? "", titleName: title.original_title ?? title.original_name ?? "")
        cell.configureTitleTableViewCell(with: titleViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
                
                guard let query = searchBar.text,
                      !query.trimmingCharacters(in: .whitespaces).isEmpty,
                      query.trimmingCharacters(in: .whitespaces).count >= 3,
                      let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                          return
                      }
                APICaller.shared.search(with: query) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let titles):
                            resultsController.titles = titles
                            resultsController.resultCollView.reloadData()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
    }
    
    
}
