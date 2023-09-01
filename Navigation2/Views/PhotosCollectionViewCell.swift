import UIKit

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    
    static let reuseIdentifier = "photosCollectionCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureUI(for photo: UIImage) {
        
      //  let photoView = PhotoImageView(frame: .zero, photo: photo)
        let photoView = PhotoImageView(frame: .zero, photo: photo)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(photoView)
        
        NSLayoutConstraint.activate([
            photoView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
        ]
        )
        
    }
}

