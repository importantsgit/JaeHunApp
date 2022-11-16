import UIKit
import SnapKit
import MapKit

class MapView: UIView {
    let map = MKMapView()
    private var artworks: [Artwork] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        map.isZoomEnabled = true
        map.isScrollEnabled = true
        map.isRotateEnabled = true
        
        self.addSubview(map)
        map.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        map.centerToLocation(initialLocation)
        ConstrainingTheCamera()
        map.delegate = self
    }
    
}

extension MapView {
    func ConstrainingTheCamera() {
        // 카메라 제한을 거는
        let oahuCenter = CLLocation(latitude: 21.4765, longitude: -157.9647)
        let region = MKCoordinateRegion(
            center: oahuCenter.coordinate,
            latitudinalMeters: 50000,
            longitudinalMeters: 60000
        )
        map.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        map.setCameraZoomRange(zoomRange, animated: true)
    }
    
    func addArtWork(artworks: [Artwork]){
        map.addAnnotations(artworks)
    }
}

extension MapView: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else {
            return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        //4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
                )
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let artwork = view.annotation as? Artwork else {
            return
        }
        
        let launchOptions = [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ]
        artwork.mapItem?.openInMaps(launchOptions: launchOptions)
    }
    
    // infobutton을 클릭하면 이것이 호출
    //code에서 Product ► Scheme ► Edit Scheme… 으로 이동 하고 왼쪽 메뉴에서 Run 을 선택한 다음 Options 탭을 선택합니다. 위치 시뮬레이션 허용 을 선택 하고 미국 하와이주 호놀룰루를 기본 위치 로 선택 합니다. 그런 다음 닫기 버튼을 클릭합니다.
    
}

private extension MKMapView {
    // 확대, 축소를 위한 크기 지정
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ){
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        // 현재 보기 원하는 지역으로 애니메이션 자동 전환함
        
        
        setRegion(coordinateRegion, animated: true)
        // MKMapView로 표시되는 영역을 표시하도록 지시
    }
}
