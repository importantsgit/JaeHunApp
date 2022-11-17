//
//  ArtWorkViews.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/17.
//

import Foundation
import MapKit

//MARK: MKMarkerAnnotationView을 상속하여 업그레이드 시키기
class ArtworkMarkerView: MKMarkerAnnotationView {
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
            
            //2 buttonColor
            markerTintColor = artwork.markerTintColer
            if let letter = artwork.discipline?.first {
                glyphText = String(letter)
            }
            
            //3 image
            glyphImage = artwork.image
        }
    }
}
