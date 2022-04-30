//
//  HeroHeaderUIView.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/30.
//

import UIKit

class HeroHeaderUIView: UIView {
    //加入一個Frame

    
    //在frame內加入UIImageView
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        
        //設定imageView內的圖片依view尺寸放大
        imageView.contentMode = .scaleToFill
        
        //讓subview的尺寸不會超出view
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    //加入兩個按鈕：播放及下載
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
    }
    
    //使用laoutSubView取代約束系統
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
