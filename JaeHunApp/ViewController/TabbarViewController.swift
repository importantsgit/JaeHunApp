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
        let tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "house_select"), tag: 0)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var twoVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: TwoViewController())
        let tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(named: "com_select"), tag: 1)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var threeVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: ThreeViewController())
        let tabBarItem = UITabBarItem(title: "문제 클라우드", image: UIImage(named: "problem_select"), tag: 3)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var fourVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: FourViewController())
        let tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named: "profile_select"), tag: 4)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    private lazy var fiveVC: UIViewController = {
        let viewController = UINavigationController(rootViewController: FiveViewController())
        let tabBarItem = UITabBarItem(title: "내 정보", image: UIImage(named: "profile_select"), tag: 4)
        viewController.tabBarItem = tabBarItem
        
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [oneVC, twoVC ,threeVC, fourVC, fiveVC]
    }
}

extension TabbarViewController {
    
    
}
