//
//  TitlePreviewViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/5/20.
//

import UIKit
import WebKit


//這個controller負責播放影片

class DetailViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry"//測試用dummy
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0//設定為0可以允許多行文字
        label.text = "Dommy content of Harry potter."
        return label
    }()
    
    private let videoPlayView: WKWebView = {
        let videoPlayView = WKWebView()
        videoPlayView.translatesAutoresizingMaskIntoConstraints = false
        videoPlayView.backgroundColor = .black
        return videoPlayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(videoPlayView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        constraint()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
     
     
    func constraint() {
        let videoPlayViewConstraint = [
            videoPlayView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            videoPlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoPlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoPlayView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLabelConstraint = [
            titleLabel.topAnchor.constraint(equalTo: videoPlayView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:  20)
        ]
        
        let overviewLabelConstraint = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(videoPlayViewConstraint)
        NSLayoutConstraint.activate(titleLabelConstraint)
        NSLayoutConstraint.activate(overviewLabelConstraint )
    }
    
    func configure(with model: VideoDetailViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else {return}
        print(url)
        videoPlayView.load(URLRequest(url: url))
    }
}

