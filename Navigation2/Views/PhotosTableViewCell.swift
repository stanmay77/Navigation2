import UIKit


final class PhotosTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "photosCell"
    
//    enum Constants: CGFloat {
//        case sideOffset = 12.0
//        case collectionInterimSpacing = 8.0
//    }
    
    lazy var photosLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Photos"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nextPhotosArrowImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(systemName: "arrow.right")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var photosCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Constants.horizontalScrollInterimSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self

        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        configureUI()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI() {
        
        addSubview(photosLabel)
        addSubview(photosCollection)
        addSubview(nextPhotosArrowImage)
        
        backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            photosLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            photosLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            
            nextPhotosArrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            nextPhotosArrowImage.centerYAnchor.constraint(equalTo: photosLabel.centerYAnchor),
            
            photosCollection.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.horizontalScrollSideOffset),
            photosCollection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.horizontalScrollSideOffset),
            photosCollection.topAnchor.constraint(equalTo: photosLabel.bottomAnchor, constant: 12),
            photosCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension PhotosTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.reuseIdentifier, for: indexPath) as? PhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configureUI(for: UIImage(named: Photo.photos[indexPath.row].name)!)
        return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (contentView.frame.width - 2*Constants.horizontalScrollSideOffset - 3*Constants.horizontalScrollInterimSpacing) / 4
        let height = width
        return CGSize(width: Double(width), height: Double(height))
    }
    
}
    


