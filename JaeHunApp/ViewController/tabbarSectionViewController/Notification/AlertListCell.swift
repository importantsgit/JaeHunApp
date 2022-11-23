//
//  AlertListCell.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/21.
//

import UIKit
import UserNotifications
import SnapKit

class AlertListCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 50, weight: .light)
        label.text = "00:00"
        
        return label
    }()
    
    var meridiemLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .light)
        label.text = "오전"
        
        return label
    }()
    
    lazy var alertSwitch: UISwitch = {
        let swi = UISwitch()
        swi.addTarget(self, action: #selector(alertSwitchValueChanged), for:.valueChanged)
        
        return swi
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupLayout()
    }
}

extension AlertListCell {
    func setupLayout() {
        [timeLabel,meridiemLabel,alertSwitch].forEach{
            self.addSubview($0)
        }
        
        meridiemLabel.snp.makeConstraints{
            $0.bottom.equalTo(timeLabel.snp.bottom).inset(8)
            $0.leading.equalToSuperview().offset(16)
            
        }
        
        timeLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(meridiemLabel.snp.trailing).offset(8)
            
        }
        
        alertSwitch.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            
        }
    }
    
    @objc func alertSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        alerts[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
    
    
}


extension UILabel  {
    func lineHeight(fontSize: CGFloat) {
        let style = NSMutableParagraphStyle()
        let lineHeight = fontSize
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        self.baselineAdjustment = .none
        
        self.attributedText = NSAttributedString(
            string: self.text ?? "",
            attributes: [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 2,
            ])

        
    }
}
