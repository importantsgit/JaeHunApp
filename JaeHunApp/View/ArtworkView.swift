//
//  ArtworkView.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import Foundation
import MapKit

//MARK: MKMarkerAnnotationView을 상속하여 업그레이드 시키기 (마커 자체를 이미지로 바꾸기)
class ArtworkView: MKAnnotationView {
    // 포인트를 처음부터 이렇게 만들기
    override var annotation: MKAnnotation? {
        willSet {
            // 1
            //MARK: mapView( _:viewFor)와 같게
            guard let artwork = newValue as? Artwork else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // 네비 버튼 이미지
            let mapsButton = UIButton(frame: CGRect(
              origin: CGPoint.zero,
              size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(UIImage(named: "Map"), for: .normal)
            rightCalloutAccessoryView = mapsButton
            
            // 서브타이틀 라벨
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = artwork.subtitle
            detailCalloutAccessoryView = detailLabel
            
            //3 image
            image = artwork.image
            
            
        }
    }
}

