//
//  File.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import UIKit
import SOPullUpView
import SnapKit
import MapKit

class MapPullUpController: UIViewController {

    var artworks: [Artwork] = []
    
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

        return view
    }()
    
    private var tableView = UITableView()
    
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
        print(artworks)
        
        tableView.register(MapDetailViewCell.self, forCellReuseIdentifier: "MapDetailViewCell")
        tableView.rowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension MapPullUpController {
    func setupLayout() {
        
        view.backgroundColor = .systemBackground
        
        [handleArea, backView, tableView].forEach{
            view.addSubview($0)
        }
        handleArea.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(20)
        }
        handleArea.addSubview(borderView)
        
        borderView.snp.makeConstraints{
            $0.height.equalTo(4)
            $0.width.equalTo(100)
            $0.center.equalToSuperview()
        }
        
        backView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(handleArea.snp.bottom)
            $0.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints{
            $0.top.equalTo(backView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tableView.backgroundColor = .systemBackground
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

extension MapPullUpController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artworks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MapDetailViewCell", for: indexPath) as?
                MapDetailViewCell else {return UITableViewCell()}
        
        let artwork = artworks[indexPath.row]
        cell.configure(with: artwork)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let artwork = artworks[indexPath.row]
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
}
