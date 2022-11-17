//
//  TwoViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import SnapKit

class TwoViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("바코드 인식하기", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        setupLayout()
        title = "카메라"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension TwoViewController {
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [button].forEach {
            view.addSubview($0)
        }
        button.snp.makeConstraints{
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
    }
    
    @objc private func buttonTap(_ sender: UIButton) {
        let vc = CameraViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc , animated: true)
    }
}
