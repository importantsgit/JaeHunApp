//
//  ViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let logo: UIImageView = {
        let image = UIImageView(image: UIImage(named: "blueLogo") ?? UIImage())
        
        return image
    }()
    
    private lazy var button: UIButton = {
        // lazy를 입력해야지 addTarget이 적용됨
        let button = UIButton()
        button.setTitle("SKIP", for: .normal)
        button.addTarget(self, action: #selector(moveVC), for: .touchUpInside)
        button.backgroundColor = .blue
        
        return button
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()

        // Do any additional setup after loading the view.
    }

}

extension ViewController {
    func setupLayout() {
        self.view.addSubview(button)
    
        
        button.snp.makeConstraints{
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    @objc func moveVC() {
        let tabbarVC = TabbarViewController()
        tabbarVC.modalTransitionStyle = .crossDissolve
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: true)
    }
    
}

