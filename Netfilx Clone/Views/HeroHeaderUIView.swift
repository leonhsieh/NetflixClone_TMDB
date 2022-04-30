//
//  HeroHeaderUIView.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/30.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    //加入一個Frame

    //加入按鈕：播放鍵及下載鍵
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("下載", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    private let playButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("播放", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        //禁用AutoResizing遮罩以使用約束
        button.translatesAutoresizingMaskIntoConstraints = false
         
        return button
    }()

    //在frame內加入UIImageView
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        
        //設定imageView內的圖片依view尺寸放大
        imageView.contentMode = .scaleAspectFit
        
        //讓subview的尺寸不會超出view
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    

    //幫header image加入漸層效果
    //TODO: 讓漸層色符合當前環境色
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
    private func applyConstraints(){
        
        //設定播放鍵的約束
        let playButtonConstraint = [
            //在英文國家中，leading方向代表左邊，但阿拉伯語係國家則是從右邊開始，使用leading作為約束方式可以讓App更有在地性
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            //使用負數作為constant，讓按鈕從下往上對齊（正數的話是從上往下margin）
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downloadButtonConstraint = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        //啟動上面的約束
        NSLayoutConstraint.activate(downloadButtonConstraint)
        NSLayoutConstraint.activate(playButtonConstraint)
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
