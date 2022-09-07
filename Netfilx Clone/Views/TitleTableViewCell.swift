//
//  UpComingTitleTableViewCell.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/18.
//

import UIKit
import SDWebImage

class TitleTableViewCell: UITableViewCell {
    
    static let identifier = "TitleTableViewCell"
    
    private let titlePosterUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false//很容易忘記加這行
        imageView.clipsToBounds = true//防止圖片從各自的容器中溢出
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        //使用titleOverview autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakStrategy = .standard
        
        return label
    }()
    
    private let playTitleButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(buttonImage, for: .normal)
        button.tintColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlePosterUIImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyConstraints()//記得要啟動auto layout
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titlePosterUIImageView.frame = contentView.bounds
    }
    
    private func applyConstraints(){
        let titlePosterUIImageViewConstraints = [
            titlePosterUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titlePosterUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            titlePosterUIImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),//橫向滿版
            titlePosterUIImageView.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterUIImageView.trailingAnchor,constant: 10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playTitleButtonConstraints = [
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(titlePosterUIImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    //使用public作為ViewModel的傳入點，model負責持有海報影像、Label文字
    public func configure(with model: TitleViewModel){
                
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        
//        titlePosterUIImageView.backgroundColor = .green

        titlePosterUIImageView.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
