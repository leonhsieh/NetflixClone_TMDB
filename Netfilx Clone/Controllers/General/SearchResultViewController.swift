//
//  SearchResultViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/18.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    //使用public，讓SearchViewControll能取用titles，
    public var titles: [Title] = [Title]()
    
    //將搜尋頁的關鍵字feed view做成colletion view
    //使用public讓SearchViewControll調用，以reload data
    public let searchResultsColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let colletionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colletionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return colletionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsColletionView)
        
        searchResultsColletionView.delegate = self
        searchResultsColletionView.dataSource = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsColletionView.frame = view.bounds
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        
        cell.configure(with: title.poster_path  ?? "Poster_path erroraa")
        
        return cell
    }
}
