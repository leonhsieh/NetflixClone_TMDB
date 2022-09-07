//
//  DownLoadViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/14.
//

import UIKit

class MyCollectionViewController: UIViewController {
    
    private var titles:[TitleItem] = [TitleItem]()//改用TItleItem，這樣可以直接從DB中直接fetch進來
    
    private let myCollectionTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self,
                       forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "收藏"
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        myCollectionTable.delegate = self
        myCollectionTable.dataSource = self
        fetchLocalStorageForDownloads()
        view.addSubview(myCollectionTable)
        addNotificationCenter()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myCollectionTable.frame = view.bounds
    }
    
    private func addNotificationCenter() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownloads()
        }    }
    
    private func fetchLocalStorageForDownloads(){//在這裡呼叫DataPersistance Method
        DataPersistanceManager.shared.fetchTitleItemFromDB { [weak self] result in//因為成功的話會得到一個array，加入weak self 避免記憶體洩漏
            switch result {
            case.success(let results):
                self?.titles = results
                DispatchQueue.main.async {
                    self?.myCollectionTable.reloadData()//取得DB中的資料後要reload

                }
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension MyCollectionViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier,for: indexPath) as? TitleTableViewCell else {return UITableViewCell() }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "Unknow Title name" ,
                                            posterURL: title.poster_path ?? "Unknow poster path"))
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //使用commit來刪除特定的row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DispatchQueue.main.async {
                DataPersistanceManager.shared.deleteTitleItemFromDB(model: self.titles[indexPath.row]) { results in

                    switch results {
                    case .success():
                        print("成功從DB中刪除")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        
        APIService.shared.getYTMovie(with: titleName) { [weak self] result in
            
            switch result {
            case.success(let videoElement):
                
                DispatchQueue.main.async {
                    let vc = DetailViewController()
                   vc.configure(with: VideoDetailViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                   
                   self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
