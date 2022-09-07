//
//  CollectionViewTableViewCell.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/30.
//

import UIKit

protocol ColletionViewTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: VideoDetailViewModel)
}


class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: ColletionViewTableViewCellDelegate?
    
    private var titles: [Title] = [Title]()

    //設定每個cell的placeholder
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        //設定collectionView裡面cell的尺寸
        layout.itemSize = CGSize(width: 140, height: 200)
        
        //設定collectionView的滑動方向為水平
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //註冊collectionView，將TitleColletionViewCell傳入
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        contentView.addSubview(collectionView)
        
        //使用delegate來顯示圖片及文字
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //有了addSubview後，需要幫subview做frame高度
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    //依據HomeViewController傳入的title來feed並更新頁面，使用public提供接口給cellforRowAt呼叫
    public func configure(with titles: [Title]){
        self.titles = titles
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {//使用Notification center讓CoreData知道下載新資料
        
        DataPersistanceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
            switch result{
            case.success():
                print("Download to database")
                //將賦予Name與sender的notification廣播到整個APP中，並在DownloadVC中使用observer監聽
                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
                
        print("Downloading\(String(describing: titles[indexPath.row].original_title))")
    }
    
}


extension CollectionViewTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //將cell更新為TitleColletionViewCell，如果失敗就回傳普通的colletionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        guard let posterPath = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: posterPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
    
    //加入didSelectItemAt作為測試request影片用
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        //把用戶選取的的title名稱，拿來搜尋影片
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.title else {return}
        
        APIService.shared.getYTMovie(with: titleName + "trailer") { [weak self] results in
            switch results {
            case .success(let videoElement):
                print(videoElement.id)
                                
                guard let titleOverView = title.overview else { return }
                guard let strongSelf = self else {return}
                
                let  viewModel = VideoDetailViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverView)
                //成功得到影片位址後，執行
                self?.delegate?.didTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //加入收藏清單
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
