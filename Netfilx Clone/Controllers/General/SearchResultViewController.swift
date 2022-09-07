//
//  SearchResultViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/18.
//

import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewControllerDidTapItem(_ viewModel: VideoDetailViewModel)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
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
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistanceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result{
            case.success():
                print("Download to database")
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
                
        print("Downloading\(String(describing: titles[indexPath.row].original_title))")
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
        
        cell.configure(with: title.poster_path  ?? "Poster_path Error 圖片路徑錯誤")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        
        //
        APIService.shared.getYTMovie(with: titleName) { [weak self] result in
            
            switch result {
            case.success(let videoElement):
                self?.delegate?.searchResultViewControllerDidTapItem(VideoDetailViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let addToCollectionAction = UIAction(title: "加入收藏",subtitle: nil,image: nil,identifier: nil,discoverabilityTitle: nil,state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
//                print("Download Tapped")
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [addToCollectionAction])
        }
        return config
    }
}
