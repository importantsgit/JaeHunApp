//
//  Artwork.swift
//  JaeHunApp
//
//  Created by 이재훈 on 2022/11/16.
//

import Foundation
import MapKit
import Contacts
// dictionaryKey를 포함하고 있음
// 위치(주소, 도시 또는 주 필드)를 세팅하려면 필요

class Artwork: NSObject, MKAnnotation { // MKAnnotation -> 마커
    let title: String?
    // 제목
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(
        title: String?,
        locationName: String?,
        discipline: String?,
        coordinate: CLLocationCoordinate2D
    ){
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    init?(feature: MKGeoJSONFeature){ // 지형지물을 모양으로 나타냄
        //1 ->
        guard
            let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData), // 데이터를 Swift Dictionary으로 디코딩하는데 사용
            let properties = json as? [String: Any]
        else {
            return nil
        }
        
        //3 -> 속성 디코딩 되었으므로 사전 값에서 적절한 속정을 설정할 수 있음
        title = properties["title"] as? String
        locationName = properties["location"] as? String
        discipline = properties["discipline"] as? String
        coordinate = point.coordinate
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    // 부제
    
    var mapItem:MKMapItem? {
        guard let location = locationName else {
            return nil
        }
        
        let addressDict = [CNPostalAddressStreetKey: location]
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: addressDict
        )
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    // 네비게이션 사용을 위해 필요
    
    
}
