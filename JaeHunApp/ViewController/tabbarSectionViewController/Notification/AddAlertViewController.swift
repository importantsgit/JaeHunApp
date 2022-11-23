//
//  AddAlertViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/21.
//

import UIKit
import SnapKit

class addAlertViewController: UIViewController {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "시간"
        
        return label
    }()
    
    lazy var datePicker: UIDatePicker = {
        let label = UIDatePicker()
        label.datePickerMode = .time
        label.locale = Locale(identifier: "ko")
        
        return label
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "save", style: .plain, target: self, action: #selector(saveButtonTapped))

        return button
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "띄울 문장"
        
        return label
    }()
    
    let placeHolder = "알람과 함께 띄울 문장을 입력하세요"
    
    lazy var textView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.textContainerInset = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        view.font = .systemFont(ofSize: 13)
        view.text = placeHolder
        view.textColor = .lightGray
        view.delegate = self
        
        return view
    }()

    
    var datePicked: ((_ date: Date, _ text: String) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
    }
}

extension addAlertViewController {
    func setupLayout() {
        view.backgroundColor = .systemBackground
        
        title = "알람 추가"
        
        [timeLabel,datePicker,textLabel, textView].forEach{
            view.addSubview($0)
        }
        timeLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.leading.equalToSuperview().offset(16)
        }
        
        datePicker.snp.makeConstraints{
            $0.centerY.equalTo(timeLabel)
            $0.trailing.equalToSuperview().inset(16)
            
        }
        
        textLabel.snp.makeConstraints{
            $0.top.equalTo(datePicker.snp.bottom).offset(24)
            $0.leading.equalTo(timeLabel)
        }
        textView.snp.makeConstraints{
            $0.top.equalTo(textLabel.snp.bottom).offset(8)
            $0.leading.equalTo(timeLabel)
            $0.trailing.equalTo(datePicker)
            $0.height.equalTo(self.view.frame.height/2)
        }
        
       // navigationItem.leftBarButtonItem = dismissButton
        navigationItem.rightBarButtonItem = addButton

    }
    
    @objc func timePickerTapped(_ sender: UIDatePicker) {
        //let date = sender.date

    }
    
    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        if textView.text == placeHolder {
            datePicked?(datePicker.date, "")
        }else {
            datePicked?(datePicker.date, textView.text)
        }

        self.navigationController?.popViewController(animated: true)
    }

}

extension addAlertViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolder
            textView.textColor = .lightGray
        }
    }
}
