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
        button.setTitle("QR코드 인식하기", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)

        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "QR코드 감별기"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        setupLayout()
        title = "카메라"
    }
}

extension TwoViewController {
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [titleLabel, button ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
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
