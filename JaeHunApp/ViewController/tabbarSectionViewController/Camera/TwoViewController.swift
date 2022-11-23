//
//  TwoViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import SnapKit
import Lottie
import Kingfisher

class TwoViewController: UIViewController {
    
    private var animationView: LottieAnimationView = {
        var uiView = LottieAnimationView(frame: .zero)
        uiView = .init(name: "scaning")
        uiView.contentMode = .scaleAspectFit
        uiView.loopMode = .loop
        
        return uiView
    }()
    
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
        label.text = "QR를 스캔해보세요"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        animationView.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animationView.stop()
    }
    
    override func viewDidLoad() {
        setupLayout()
        title = "QR Scanning"

    }
}

extension TwoViewController {
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [animationView, titleLabel, button ].forEach {
            view.addSubview($0)
        }
        
        animationView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(view.frame.width/2)
            $0.height.equalTo(animationView.snp.width)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(animationView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
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
