import MapKit

protocol MapTypeOptionDelegateProtocol: AnyObject {
    func didSelectMapType(_ type: MKMapType)
}


class MapTypeViewController: UIViewController {
    
    weak var delegate: MapTypeOptionDelegateProtocol?
    
    let mapTypes: [MKMapType] = [.standard, .satellite]
    
    let mapTypeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(MapTypeCollectionViewCell.self, forCellWithReuseIdentifier: MapTypeCollectionViewCell.cellID)
        return collection
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapTypeCollectionView)
        
        mapTypeCollectionView.delegate = self
        mapTypeCollectionView.dataSource = self
    
        
        NSLayoutConstraint.activate([
            mapTypeCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            mapTypeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            mapTypeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            mapTypeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100)
        ])
        
    }

}

extension MapTypeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MapTypeCollectionViewCell.cellID, for: indexPath) as? MapTypeCollectionViewCell
            else { return UICollectionViewCell() }
        cell.configureCell(for: mapTypes[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.bounds.width - 20) / 2
        let height = width
        return CGSize(width: Double(width), height: Double(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectMapType(mapTypes[indexPath.row])
        self.dismiss(animated: true)
    }
    
}
