//
//  BeerDetailViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/18.
//

import UIKit

class BeerDetailViewController: UITableViewController {
    var beer: Beer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .always
        
        title = beer?.name ?? "이름 없는 맥주"
        
        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BeerDetailListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.preservesSuperviewLayoutMargins = true
        tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .systemBackground
        
        let headerView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        let imageURL = URL(string: beer?.imageURL ?? "")
        headerView.contentMode = .scaleAspectFit
        headerView.kf.setImage(with: imageURL
                               ,options: [.transition(.fade(2)),  .forceTransition])
        tableView.tableHeaderView = headerView
    }
}

extension BeerDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return beer?.foodParing?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "아이디"
        case 1:
            return "설명"
        case 2:
            return "음료 팁"
        case 3:
            let foodParing = beer?.foodParing?.count ?? 0
            let containFoodParing = foodParing != 0
            return containFoodParing ? "Food Paring" : nil
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "BeerDetailListCell")
        var content = cell.defaultContentConfiguration()
        content.textProperties.numberOfLines = 0

        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            content.text = String(describing: beer?.id ?? 0)
        case 1:
            content.text = beer?.description ?? "설명 없는 맥주"
        case 2:
            content.text = beer?.brewersTips ?? "팁 없는 맥주"
        default:
            content.text = beer?.foodParing?[indexPath.row] ?? ""
        }
        
        cell.contentConfiguration = content
        return cell
        
    }
}
