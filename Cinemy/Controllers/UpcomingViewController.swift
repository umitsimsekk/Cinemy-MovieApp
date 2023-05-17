//
//  UpcomingViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit

class UpcomingViewController: UIViewController {

    var titles: Array<Title> = []
    private let upcomingTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        
        view.addSubview(upcomingTableView)
        setTableViewDelegates()
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
}
extension UpcomingViewController {
    private func setTableViewDelegates(){
        self.upcomingTableView.delegate = self
        self.upcomingTableView.dataSource = self
    }
    private func fetchData(){
        APICaller.shared.getUpcomingMovies { result in
            switch result {
            case .success(let title):
                self.titles = title
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension UpcomingViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let titleViewModel = TitleViewModel(posterUrl: title.poster_path ?? "", titleName: title.original_name ?? title.original_title ?? "")
        cell.configureTitleTableViewCell(with: titleViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
