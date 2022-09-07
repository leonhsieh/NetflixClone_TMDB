//
//  ViewController.swift
//  Netfilx Clone
//
//  Created by leon on 2022/4/13.
//
//Use different VC for each element.

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow
        overrideUserInterfaceStyle = .dark
        
        // Assign HomeViewController as a new root navigation controller to vc1 and initialize it.
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: MyCollectionViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "heart")
        
//        Assign label color to tint color of all tabBar items.
        tabBar.tintColor = .label        
        
        vc1.title = "首頁"
        vc2.title = "即將上線"
        vc3.title = "搜尋"
        vc4.title = "收藏"
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
    }


}

