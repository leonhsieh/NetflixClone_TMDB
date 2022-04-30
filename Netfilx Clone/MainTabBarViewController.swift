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
        
        // Assign HomeViewController as a new root navigation controller to vc1 and initialize it.
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownLoadViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.forward.square")
        
//        Assign label color to tint color of all tabBar items.
        tabBar.tintColor = .label        
        
        vc1.title = "Home"
        vc2.title = "Comming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
    }


}

