//
//  HomeViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/14.
//

import UIKit

class HomeViewController: UIViewController {
    
    //將title的文本內容放在array中
    let sectionTitles: [String] = ["現正熱播", "最新發行", "即將上映", "重新回味"]
    
    
//    使用匿名Closure Pattern
    private let homeFeedTable: UITableView = {
        //使用style property將cell加入section
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()

        //設定tableHeader
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        homeFeedTable.tableHeaderView = headerView
    }
    
    // TODO: 修正navBarLeftItem位置
    private func configureNavbar(){
        var image = UIImage(named: "netflixLogo")
//        var image = UIImage(systemName: "network")
        image = image?.withRenderingMode(.alwaysOriginal)        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "airplayvideo"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    //設定TableView的大小與螢幕相同
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    //設定TableView的行數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //設定TableView上面每行cell物件及內容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //使用willDisplayHeaderView可以預先載入動態資料，讓view的生命週期更完整
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }

        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white

    }
    
    //雖然viewForHeaderInSection就能完成label的設定工作，但這比較適合沒有牽涉到API或networking的label內容
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        let headerLabel = UILabel(frame: CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height))
        
        headerLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        headerLabel.text = sectionTitles[section]
        headerLabel.textColor = .white
        headerLabel.sizeToFit()
        
        header.addSubview(headerLabel)
//        header.backgroundColor = .red
        return header
    }
     */
    
    
    //回傳各Section的標題
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    //設定navBar滑動效果
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  defaultOffset = view.safeAreaInsets.top
        
        //往上滑動的值＝往下捲動的值＋
        let offset = scrollView.contentOffset.y + defaultOffset
        
        //設定navBar隨著頁面往下捲動，當contenView碰到navBar時，朝上移動
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        
    }
    
    
}
