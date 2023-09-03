import UIKit
import MapKit
import CoreLocation

class LocationVC: UIViewController {
    
    let mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsCompass = true
        map.mapType = .hybrid
        map.showsTraffic = true
        return map
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
        mapView.delegate = self
        
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addAnnotationTap))
        mapView.addGestureRecognizer(doubleTapRecognizer)
        doubleTapRecognizer.numberOfTapsRequired = 1
        
        let longTapRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(deleteAnnotationTap))
        mapView.addGestureRecognizer(longTapRecognizer)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
        
        
        let action = UIAlertAction(title: "Ok", style: .default) {_ in
            
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coord
            annotation.title = alertVC.textFields?[0].text ?? "No label"
            self.mapView.addAnnotation(annotation)
            
        }
        alertVC.addAction(action)
        present(alertVC, animated: true)
        
    }
    
    @objc func deleteAnnotationTap(_ recognizer: UILongPressGestureRecognizer) {
        
        let location = recognizer.location(in: mapView)
        let coord = mapView.convert(location, toCoordinateFrom: mapView)

        
        if let annotationToDelete = findAnnotation(at: coord, for: mapView) {
            
            mapView.removeAnnotation(annotationToDelete)
        }

                
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

}


extension LocationVC: CLLocationManagerDelegate, MKMapViewDelegate {
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
}

