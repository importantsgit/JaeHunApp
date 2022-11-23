//
//  TabbarViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit

class TabbarViewController: UITabBarController {
    private lazy var oneVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: OneViewController())
        let tabBarItem = UITabBarItem(title: "지도", image: UIImage(named: "map"), tag: 0)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var twoVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: TwoViewController())
        let tabBarItem = UITabBarItem(title: "카메라", image: UIImage(named: "camera"), tag: 1)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var threeVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: ThreeViewController())
        let tabBarItem = UITabBarItem(title: "음료", image: UIImage(named: "drink"), tag: 3)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var fourVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: FourViewController())
        let tabBarItem = UITabBarItem(title: "알림", image: UIImage(named: "note"), tag: 4)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var fiveVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: FiveViewController())
        let tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named: "profile_select"), tag: 5)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [oneVC, twoVC ,threeVC,fourVC]
        view.backgroundColor = .systemBackground
        tabBarLayout()
    }
}

extension TabbarViewController {
    func tabBarLayout() {
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = .systemBackground
        self.tabBar.tintColor = .black
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
}
