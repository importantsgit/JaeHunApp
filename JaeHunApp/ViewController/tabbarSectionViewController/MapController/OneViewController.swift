//
//  OneViewController.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import UIKit
import SnapKit
import MapKit
import SOPullUpView

class OneViewController: UIViewController {
    private var mapView = MapView()

    var bottomPadding: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        return window?.safeAreaInsets.top ?? 0.0
    }
    
    var artworks: [Artwork] = []
    
    let pullUpControl = SOPullUpControl()

    
    override func viewDidLoad() {
        setupLayout()
        mapView.setup()
        fetchLocation()
        mapView.addArtWork(artworks: artworks)
        pullUpControl.dataSource = self
        pullUpControl.setupCard(from: view)

    }
}

extension OneViewController {
    private func setupLayout() {
        title = "Map"
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }


    }
    
    //MARK: Add Location -> Decoding File
    private func fetchLocation() {
        guard
            let fileName = Bundle.main.url(forResource: "Public Art", withExtension: "geojson"),
            let artworkData = try? Data(contentsOf: fileName) // 파일을 일고
        else {
            print("Unexpected error: unDecoded.")
            return
        }
        
        do {
            let feature = try MKGeoJSONDecoder() // 디코더를 이용하여 디코딩
                .decode(artworkData)
                .compactMap{ $0 as? MKGeoJSONFeature }
            // 1차원 배열에서 nil을 제거하고 옵셔널 바인딩을 하고 싶을때 compactMap
            // 2차원 배열을 1차원 배열로 바꾸고 싶다면
            
            let validWorks = feature.compactMap(Artwork.init)
            
            self.artworks.append(contentsOf: validWorks)
        } catch {
            print("Unexpected error: \(error).")
        }
        
    }
}

extension OneViewController: SOPullUpViewDataSource  {
    
    func pullUpViewCollapsedViewHeight() -> CGFloat {
         return bottomPadding + 60
    }
    
    func pullUpViewExpandedViewHeight() -> CGFloat {
        return view.frame.height - 100
    }
    
    func pullUpViewController() -> UIViewController {
        let vc = MapPullUpController()
        vc.artworks = artworks
        vc.pullUpControl = self.pullUpControl
        
        return vc
    }
}


