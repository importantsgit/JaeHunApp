//
//  OneViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import SnapKit
import MapKit

class OneViewController: UIViewController {
    private var mapView = MapView()
    
    let artworks: [Artwork] = []
    
    override func viewDidLoad() {
        setupLayout()
        mapView.setup()
        mapView.addArtWork(artworks: artworks)
    }
}

extension OneViewController {
    private func setupLayout() {
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func loadInitialData() {
        // 1
        //guard let fileName = Bundle.main
    }
}


