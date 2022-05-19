//
//  SearchViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/14.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var titles:[Title] = [Title]()

    
    //加入searBar & TableView
    private let discoverTable: UITableView = {
        let searchTable = UITableView()
        searchTable.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return searchTable
    }()
    
    private let searchController: UISearchController = {
        
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "搜尋電影或影集"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.setValue("取消", forKey: "cancelButtonText")
        return controller
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "搜尋"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        view.addSubview(discoverTable)
        
        //加入searchBar得使用navigationItem
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .white//改變navBar按鈕顏色
        fetchDiscoverMovies()
        
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        APIService.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //還沒有資料傳入時的暫時設定
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "Unknow title",
                                            posterURL: title.poster_path ?? "Unknow poster path"))
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
              !query.trimmingCharacters(in: .whitespaces).isEmpty,//以空白鍵作為單字間隔符號，searchBar內有字才搜尋
              query.trimmingCharacters(in: .whitespaces).count >= 3,//三個字母以上才會執行搜尋，減低server壓力
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        
        APIService.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsColletionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
}
