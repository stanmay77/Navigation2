import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController, MapTypeOptionDelegateProtocol {
    
    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsCompass = true
        map.mapType = .hybrid
        map.showsTraffic = true
        return map
    }()
    
    
    lazy var mapTypeOverlayView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .tertiarySystemBackground
        view.layer.cornerRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var mapTypeLabel: UIImageView = {
        let label = UIImageView(frame: .zero)
        label.image = UIImage(systemName: "globe")
        label.tintColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var routeInfoOverlayView: UIView = {
        let view = UIView(frame: .zero)
        //view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setLocationManager()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backBarButtonItem?.tintColor = .white
        navigationItem.title = "Your location"
        view.addSubview(mapView)
        view.addSubview(mapTypeOverlayView)
        mapTypeOverlayView.addSubview(mapTypeLabel)
        view.addSubview(routeInfoOverlayView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 8
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        routeInfoOverlayView.addSubview(blurView)
        routeInfoOverlayView.addSubview(distanceLabel)
        mapView.delegate = self
        routeInfoOverlayView.isHidden = true
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseMapTypeTap))
        mapTypeOverlayView.addGestureRecognizer(tapGesture)
        
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAnnotationTap))
        mapView.addGestureRecognizer(doubleTapRecognizer)
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delegate = self
        
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteAnnotationTap))
        mapView.addGestureRecognizer(longTapRecognizer)
        
        for gesture in mapView.gestureRecognizers! {
                    if let tapGesture = gesture as? UITapGestureRecognizer, tapGesture.numberOfTapsRequired == 2 {
                        tapGesture.require(toFail: doubleTapRecognizer)
                    }
                }
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            mapTypeOverlayView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            mapTypeOverlayView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10),
            mapTypeOverlayView.widthAnchor.constraint(equalToConstant: 38),
            mapTypeOverlayView.heightAnchor.constraint(equalToConstant: 38),
            
            mapTypeLabel.centerXAnchor.constraint(equalTo: mapTypeOverlayView.centerXAnchor),
            mapTypeLabel.centerYAnchor.constraint(equalTo: mapTypeOverlayView.centerYAnchor),
            mapTypeLabel.widthAnchor.constraint(equalTo: mapTypeOverlayView.widthAnchor, multiplier: 0.7),
            mapTypeLabel.heightAnchor.constraint(equalTo: mapTypeOverlayView.heightAnchor, multiplier: 0.7),
            
            routeInfoOverlayView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 50),
            routeInfoOverlayView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 10),
            routeInfoOverlayView.widthAnchor.constraint(equalToConstant: 170),
            routeInfoOverlayView.heightAnchor.constraint(equalToConstant: 40),
            
            blurView.topAnchor.constraint(equalTo: routeInfoOverlayView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: routeInfoOverlayView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: routeInfoOverlayView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: routeInfoOverlayView.trailingAnchor),
            
            distanceLabel.centerXAnchor.constraint(equalTo: routeInfoOverlayView.centerXAnchor),
            distanceLabel.centerYAnchor.constraint(equalTo: routeInfoOverlayView.centerYAnchor),
 
            mapTypeOverlayView.widthAnchor.constraint(equalToConstant: 150),
            mapTypeOverlayView.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            setLocationManager()
        case .denied, .restricted:
            let alertVC = UIAlertController(title: "Error", message: "Location services not enabled or restricted!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default)
            alertVC.addAction(alertAction)
            present(alertVC, animated: true)
            
        case .authorizedAlways, .authorizedWhenInUse:
            setLocationManager()
        @unknown default:
            print("Some other choice")
        }
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @objc func addAnnotationTap(_ recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: mapView)
        let coord = mapView.convert(location, toCoordinateFrom: mapView)
        print(coord)
        let alertVC = UIAlertController(title: "Add annotation", message: "Enter your POI name", preferredStyle: .alert)
        
        alertVC.addTextField { textField in
            textField.text = "Enter POI name"
        }
        
        
        let action = UIAlertAction(title: "Add", style: .default) {_ in

            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = alertVC.textFields?[0].text ?? "No label"
            self.mapView.addAnnotation(annotation)
        }
        
        alertVC.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true)
        
    }
    
    @objc func deleteAnnotationTap(_ recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.location(in: mapView)
        let coord = mapView.convert(location, toCoordinateFrom: mapView)

        
        if let annotationToDelete = findAnnotation(at: coord, for: mapView) {
            mapView.removeAnnotation(annotationToDelete)
        }

                
    }
    
    @objc func chooseMapTypeTap() {
        let mapTypeVC = MapTypeViewController()
        mapTypeVC.modalPresentationStyle = .pageSheet
        mapTypeVC.delegate = self
        present(mapTypeVC, animated: true)
    }
    
    func findAnnotation(at coordinate: CLLocationCoordinate2D, for view: MKMapView) -> MKAnnotation? {
        
        var coordPoint = view.convert(coordinate, toPointTo: view)
        
        let annotations = view.annotations.filter({
            let annotPoint = view.convert($0.coordinate, toPointTo: view)
            let distance = sqrt(pow((annotPoint.x - coordPoint.x), 2) + pow((annotPoint.y - coordPoint.y), 2))
            return distance < 50
        }
            )
        
        return annotations.last

    }
    
    func didSelectMapType(_ type: MKMapType) {
        mapView.mapType = type
    }
    
    func getRoute(to targetLocation: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: locationManager.location!.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: targetLocation))
        request.transportType = .automobile
        
        let route = MKDirections(request: request)
        route.calculate { (response, error) in
            
            if let error {
                print(error.localizedDescription)
            }
            
            if let rr = response?.routes.first {
                self.mapView.addOverlay(rr.polyline, level: .aboveRoads)
                self.routeInfoOverlayView.isHidden = false
                self.distanceLabel.text = "🎯 Distance: \(String(format: "%.1f", rr.distance/1000)) km"
            }
            
        }
        
    }

}


extension LocationVC: CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        
        mapView.setCenter(location, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.mapView.setRegion(MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)), animated: true)
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        
        
        let reuseIdentifier = "MapMarker"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = UIColor.orange
        annotationView?.glyphText = "📍"
        annotationView?.canShowCallout = true
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        for overlay in mapView.overlays {
            if overlay is MKPolyline {
                mapView.removeOverlay(overlay)
            }
        }
        
        getRoute(to: annotation.coordinate)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}

