//
//  File.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import UIKit
import SOPullUpView
import SnapKit

class MapPullUpController: UIViewController {

    private var handleArea: UIView = {
        let view = UIView()
        view.backgroundColor =  .systemBackground
        
        return view
    }()
    
    private var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    private var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        
        return stackView
    }()
    
    var pullUpControl: SOPullUpControl? {
        didSet {
            pullUpControl?.delegate = self
        }
    }
    
    override func viewDidLoad() {
        setupLayout()
    }
}

extension MapPullUpController {
    func setupLayout() {
        [handleArea, backView].forEach{
            view.addSubview($0)
        }
        handleArea.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        handleArea.addSubview(borderView)
        
//        stackView.snp.makeConstraints{
//            $0.leading.trailing.top.bottom.equalToSuperview()
//        }
//
//        [
//            borderView
//        ].forEach {
//            stackView.addArrangedSubview($0)
//        }
        
        borderView.snp.makeConstraints{
            $0.height.equalTo(4)
            $0.width.equalTo(300)
            $0.center.equalToSuperview()
        }
        
        backView.snp.makeConstraints{
            $0.top.equalTo(handleArea.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(800)
            $0.bottom.equalToSuperview()
        }
    }
}

extension MapPullUpController: SOPullUpViewDelegate {
    
    
    func pullUpViewStatus(_ sender: UIViewController,didChangeTo status: PullUpStatus) {
        print("SOPullUpView status is \(status)")
    }
    
    func pullUpHandleArea(_ sender: UIViewController) -> UIView {
        return handleArea
    }
}
