//
//  FourViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import UserNotifications

class FourViewController: UITableViewController {
    var alerts:[Alert] = []
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.alerts = alertList()
    }
    
    override func viewDidLoad() {
        title = "알람"
        tableView.register(AlertListCell.self, forCellReuseIdentifier: "AlertListCell")
        navigationItem.rightBarButtonItem = addButton
        

        
    }
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAlertButtonAction))
        


        return button
    }()
}

extension FourViewController {
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else {return []}
        return alerts
    }
    
    @objc func addAlertButtonAction(_ sender: UIBarButtonItem) {
        let addVC = addAlertViewController()
       
        addVC.datePicked = {[weak self] date, text in
           guard let self = self else { return }
           var alertList = self.alertList()
            let newAlert = Alert(date: date, isOn: true, text: text)
           
           alertList.append(newAlert)
           alertList.sort { $0.date < $1.date }
           self.alerts = alertList
           
           UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
           
           self.userNotificationCenter.addNotificationRequest(by: newAlert)
           

           self.tableView.reloadData()
       }
        addVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(addVC, animated: true)
   }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "입력된 시간"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        
        cell.alertSwitch.tag = indexPath.row
        cell.alertSwitch.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].meridiem
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[indexPath.row].id])
            self.alerts.remove(at: indexPath.row)
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts")
            tableView.reloadData()
        default:
            break
        }
    }
}
