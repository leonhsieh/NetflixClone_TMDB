//
//  HeroHeaderUIView.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/30.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    //0:先init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
//        addSubview(addToListButton)
        applyConstraints()
    }
    
    //0:同時避免錯誤
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //1.在frame內加入UIImageView
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit//設定imageView內的圖片依view尺寸放大
        imageView.clipsToBounds = true//讓subview的尺寸不超出superview
        imageView.image = UIImage(named: "heroImage")
        return imageView
    }()
    
    //加入下載鍵按鈕
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("下載", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    //加入播放鍵按鈕
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("播放", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false//禁用AutoResizing遮罩以使用約束
        return button
    }()
    
    private let addToListButton: UIButton = {
        let button = UIButton()
        button.setTitle("我的片單", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
       return button
    }()

    //幫header image加入漸層效果
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        
        //使用兩個顏色作為漸層色：clear及系統背景色
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor,
        ]
        
        //要加入frame漸層才能顯示
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    

    //加入約束
    private func applyConstraints(){
        
        //設定播放鍵的約束
        let playButtonConstraint = [
            
            //在英文系及中文系國家中，leading方向代表左邊，
            //但阿拉伯語係國家則是從右邊開始，使用leading作為約束方式可以讓App更有在地性
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            
            //使用負數，讓按鈕從下往上對齊（正數的話是從上往下margin）
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let downloadButtonConstraint = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        //TODO: 將三個按鈕加入StackView並均分排列
        /*
        let addToListButtonContraint = [
            addToListButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            addToListButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            addToListButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        */
        
        //啟動約束
        NSLayoutConstraint.activate(downloadButtonConstraint)
        NSLayoutConstraint.activate(playButtonConstraint)
    }
    
    //使用public，讓configure可以從Controller調用
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
        heroImageView.sd_setImage(with: url)
    }
    
    //使用laoutSubView取代約束系統
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
}
