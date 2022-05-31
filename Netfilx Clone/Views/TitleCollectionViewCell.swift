//
//  TitleCollectionViewCell.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/18.
//

import UIKit
import SDWebImage

//使用自訂的colletion view cell取代預設，負責Colletion view內所有的顯示元件
class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    //加入image view，作為放置海報用
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    
    //TODO: 釐清為什麼colletion view需要 required init
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    //讓subview 符合titleOverview view外框即可
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    //加入update function到每個imageCell，每次把cell從對列中移除
    public func configure(with model: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
        
        /*
        print(model)
        //poster的url位址由model傳入，轉為URL位址後提供給SDWebimage
        guard let url = URL(string: model) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
         */
    }
    
}
