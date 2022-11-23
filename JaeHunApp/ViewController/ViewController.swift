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
    
    let label: UILabel = {
       
        let label = UILabel()
        label.text = """
        MapKit을 이용
        1. pullUpPage와의 데이터 연동
        2. Annotation을 활용한 마커 제공 방법
        3. 마커 클릭시 애플 네비게이션 연결 방법
        
        AVFoundation/Vision을 이용
        1. Vision
        - 얼굴인식, 텍스트 읽기, 이미지 등록, 트랙킹
        2. AVFoundation
        - 카메라 사용
        3. AVCaptureVideoDataOutput
        - 카메리를 통해 들어오는 비디오 정보들을 이 클래스 안에서 처리
        
        URLSession/UITableViewDataSourcePrefetching
        1. URLSession/Share을 통한 데이터 가져오기
        2. 디코딩
        preFetching으로 데이터 미리 받아오기
        백그라운드로 옮겨와 처리함
        """
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 14)
        
        return label
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
        [label, button].forEach{
            view.addSubview($0)
        }

        label.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
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

