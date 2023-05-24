//
//  DownloadsViewController.swift
//  Cinemy
//
//  Created by Ümit Şimşek on 16.05.2023.
//

import UIKit

class DownloadsViewController: UIViewController {
    var titles : Array<TitleItem> = []
    
    private let downloadTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .gray
        view.addSubview(downloadTableView)
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        setDownloadTableViewDelegates()
        fetchData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.downloadTableView.frame = view.bounds
    }
  
}

extension DownloadsViewController{
    private func setDownloadTableViewDelegates(){
        self.downloadTableView.delegate = self
        self.downloadTableView.dataSource = self
    }
    
    private func fetchData(){
        DataPersistenceManager.shared.fetchDataFromDatabase { [weak self] result in
            switch result {
            case .success(let titleItem):
                self?.titles = titleItem
                DispatchQueue.main.async {
                    self?.downloadTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension DownloadsViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        let titleViewModel = TitleViewModel(posterUrl: title.poster_path ?? ""
                                            , titleName: title.original_name ?? title.original_title ?? "")
        cell.configureTitleTableViewCell(with: titleViewModel)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteDataFromDatabase(model: titles[indexPath.row]) {[weak self] result in
                switch result{
                case .success():
                    print("Deleted")
                case.failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
        default:
            break
        }
    }
}

