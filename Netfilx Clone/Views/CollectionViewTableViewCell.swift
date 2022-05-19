//
//  CollectionViewTableViewCell.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/30.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
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
    
}


extension CollectionViewTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //將cell更新為TitleColletionViewCell，如果失敗就回傳普通的colletionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        guard let posterPath = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: posterPath)
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = .green
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return titles.count
    }
}
